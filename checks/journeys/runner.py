"""Walk a journey on a device and record what it actually traversed.

The recorded traversal is the point. A step wired into a flow nothing reaches
will compile, will read correctly in the flow's own configuration, and will
never be shown; the only thing that catches it is walking the flow and noticing
the step did not come. So a screen that does not appear is reported as **not
traversed**, naming it, rather than as a failure somewhere downstream.

Nothing is installed on the device. The walk drives it through `adb` alone —
`uiautomator dump` to see, `input tap` to act — because the first-boot journey
runs before the device is provisioned, and installing an agent or a test package
at that moment perturbs exactly what is being measured.
"""
from __future__ import annotations

import os
import re
from xml.sax import saxutils
import subprocess
import time
from dataclasses import dataclass, field

from probes import ProbeError, _adb, resumed_activity, ui_dump


@dataclass
class Step:
    """What happened at one point of the walk."""

    screen: str
    reached: bool
    activity: str = ""
    note: str = ""
    texts: tuple[str, ...] = ()
    """What the screen showed when it was reached.

    Captured during the walk because it cannot be captured afterwards: by the
    time a check runs, the wizard has moved on. Recording it turns one traversal
    into evidence for every assertion about what a step offered, instead of one
    walk per question.
    """


@dataclass
class Walk:
    """The outcome of walking a journey once."""

    journey: str
    device: str
    steps: list[Step] = field(default_factory=list)
    deviations: list[str] = field(default_factory=list)

    @property
    def traversed(self) -> list[str]:
        return [s.screen for s in self.steps if s.reached]

    @property
    def missed(self) -> list[str]:
        return [s.screen for s in self.steps if not s.reached]

    def showed(self, screen: str) -> tuple[str, ...]:
        """What the named step showed, or () if it was never reached."""
        for step in self.steps:
            if step.screen == screen and step.reached:
                return step.texts
        return ()

    @property
    def everything_shown(self) -> list[str]:
        """Every label the walk met, across all the steps it reached."""
        seen: list[str] = []
        for step in self.steps:
            for t in step.texts:
                if t not in seen:
                    seen.append(t)
        return seen

    def diff(self, other: "Walk") -> dict[str, list[str]]:
        """Steps one walk traversed and the other did not.

        Running the same journey on the build under test and on a reference
        turns the two traversals into a comparison: a step the reference shows
        and the build does not is either an upstream restructuring or a step
        lost in a port, and telling those apart is a judgement — so this
        reports rather than asserts.
        """
        mine, theirs = self.traversed, other.traversed
        return {"only_here": [s for s in mine if s not in theirs],
                "only_there": [s for s in theirs if s not in mine]}


def wait_for(screen, serial: str, timeout: float = 30.0, poll: float = 1.0) -> bool:
    """Whether `screen` becomes the foreground before `timeout`."""
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        try:
            if screen.matches(serial):
                return True
        except ProbeError:
            pass
        time.sleep(poll)
    return False


def _find(serial: str, label: str):
    """Locate a node by its visible label.

    The hierarchy is XML, so its attributes are escaped: the entry a user reads
    as *Network & internet* appears as `text="Network &amp; internet"`. Matching
    the raw label finds nothing, and a great many settings entries contain an
    ampersand — the failure reads as "the entry is missing", which is the wrong
    conclusion about the build.
    """
    pattern = (r'text="' + re.escape(saxutils.escape(label))
               + r'"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"')
    return re.search(pattern, ui_dump(serial))


def tap_text(serial: str, label: str, scrolls: int = 3) -> None:
    """Tap the node whose text is `label`, scrolling to it if it is below the fold.

    Never a coordinate from a previous run: bounds move with density, locale and
    font size, and a hard-coded tap is the classic way a UI test rots into
    tapping whatever happens to be there.

    The scroll matters more than it looks. A setup screen puts its buttons under
    the content, and a long title pushes them off a short screen — the welcome
    screen of this very wizard does exactly that. Without scrolling, the walk
    reports "no button" and a reader concludes the screen is broken when it is
    merely taller than the display.
    """
    for attempt in range(scrolls + 1):
        m = _find(serial, label)
        if m:
            x1, y1, x2, y2 = (int(g) for g in m.groups())
            _adb(serial, "shell", "input", "tap", str((x1 + x2) // 2), str((y1 + y2) // 2))
            return
        if attempt < scrolls:
            _adb(serial, "shell", "input", "swipe", "540", "1500", "540", "600", "300")
            time.sleep(1.0)
    raise ProbeError(
        f'no node labelled "{label}" on the current screen, after {scrolls} scrolls')


def capture(serial: str, out_dir: str, name: str) -> str | None:
    """Save a screenshot, for the record and for diagnosing a failure."""
    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, f"{name}.png")
    try:
        png = subprocess.run(["adb", "-s", serial, "exec-out", "screencap", "-p"],
                             capture_output=True, timeout=30).stdout
    except (subprocess.SubprocessError, OSError):
        return None
    if not png:
        return None
    with open(path, "wb") as fh:
        fh.write(png)
    return path


def diagnose(serial: str, out_dir: str, name: str) -> str:
    """Everything worth having when a step fails, gathered at the moment it does."""
    os.makedirs(out_dir, exist_ok=True)
    parts = []
    try:
        parts.append(f"foreground: {resumed_activity(serial)}")
    except ProbeError as exc:
        parts.append(f"foreground: unavailable ({exc})")
    try:
        dump = ui_dump(serial)
        texts = re.findall(r'text="([^"]+)"', dump)
        parts.append("texts on screen: " + ", ".join(t for t in texts if t)[:400]
                     if texts else "hierarchy is empty (FLAG_SECURE, or nothing drawn)")
    except ProbeError as exc:
        parts.append(f"hierarchy: unavailable ({exc})")
    shot = capture(serial, out_dir, f"{name}-failure")
    if shot:
        parts.append(f"screenshot: {shot}")
    with open(os.path.join(out_dir, f"{name}-logcat.txt"), "w") as fh:
        fh.write(_adb(serial, "logcat", "-d", "-t", "200"))
    return "\n".join(parts)


def walk(journey, serial: str, out_dir: str, timeout: float = 30.0) -> Walk:
    """Walk the journey once, recording what was reached and what was not."""
    result = Walk(journey=journey.name, device=serial)

    for screen in journey.screens:
        name = screen.activity.lstrip(".").split(".")[-1]

        if screen.applies is not None and not screen.applies(serial):
            result.steps.append(Step(name, False, note="does not apply to this device"))
            continue

        if not wait_for(screen, serial, timeout=timeout):
            try:
                where = resumed_activity(serial)
            except ProbeError:
                where = "unknown"
            if screen.optional:
                result.steps.append(Step(name, False, activity=where, note="optional, skipped"))
            else:
                result.steps.append(Step(name, False, activity=where, note="never reached"))
                result.deviations.append(
                    f"{name} was expected and did not come; the device was on {where}")
            continue

        activity = resumed_activity(serial)
        capture(serial, out_dir, f"{len(result.steps):02d}-{name}")
        try:
            texts = tuple(dict.fromkeys(
                saxutils.unescape(t) for t in re.findall(r'text="([^"]+)"', ui_dump(serial))))
        except ProbeError:
            texts = ()          # FLAG_SECURE, or a screen that never goes idle
        result.steps.append(Step(name, True, activity=activity, texts=texts))

        try:
            screen.leave(serial)
        except (ProbeError, AttributeError, NotImplementedError) as exc:
            result.deviations.append(f"could not leave {name}: {exc}")
            break

    return result
