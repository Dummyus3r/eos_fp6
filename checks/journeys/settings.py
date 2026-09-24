"""Driving the Settings application, and reading a screen once it has settled.

Three mistakes are worth designing against, all met while building this:

* **the screen has not arrived yet.** `am start` returns immediately; dumping
  straight after it reads the *previous* screen and reports its content as the
  new one. Every navigation here waits for the resumed activity to match and
  for the hierarchy to stop changing.
* **`$` belongs to the device's shell.** `am start -n .../.Settings$Foo` loses
  everything after the dollar and silently lands on the settings home page. The
  component is quoted for the far-side shell, never for ours.
* **a settings screen is taller than the display.** Reading only the first
  screenful finds no entry and concludes the entry is absent, which is the
  single easiest way to write a check that lies. Reading is a scroll to the
  bottom, gathering as it goes.
"""
from __future__ import annotations

import re
from xml.sax import saxutils
import time

from probes import ProbeError, resumed_activity, ui_dump, _adb

# A long duration makes this a drag rather than a fling. A fling keeps the
# window busy while it decelerates, and `uiautomator dump` refuses to capture a
# window that will not go idle, so a quick swipe costs more waiting than it saves.
SWIPE_UP = ("540", "1500", "540", "600", "800")
SWIPE_DOWN = ("540", "600", "540", "1500", "800")


def _texts(dump: str) -> list[str]:
    """The visible labels of a screen, as a user would read them.

    Unescaped: the hierarchy is XML, and a caller comparing against
    `"Security & privacy"` would never match the `&amp;` the dump carries.
    """
    seen = []
    for t in re.findall(r'text="([^"]*)"', dump):
        t = saxutils.unescape(t).strip()
        if t and t not in seen:
            seen.append(t)
    return seen


def settle(serial: str, expect: str = "", timeout: float = 25.0) -> str:
    """Wait for the foreground activity to match `expect` and the screen to stop moving.

    Stability is judged on the hierarchy with its digits removed. Several
    settings screens carry a value that ticks — up time, battery percentage, a
    storage figure — and comparing the raw dump would never find two identical
    ones, so a screen that is perfectly settled would time out. Reaching the
    right activity is the hard requirement; stability is best effort, and the
    timeout returns what was reached rather than inventing a failure.
    """
    deadline = time.time() + timeout
    last, stable, matched = None, 0, ""
    while time.time() < deadline:
        try:
            act = resumed_activity(serial)
        except ProbeError:
            time.sleep(0.5)
            continue
        if expect and expect not in act:
            last, stable, matched = None, 0, ""
            time.sleep(0.5)
            continue
        matched = act                  # the hard requirement is met from here on
        try:
            dump = ui_dump(serial, retries=1, delay=0)
        except ProbeError:
            time.sleep(0.5)            # still busy; the activity is right, wait it out
            continue
        steady = re.sub(r"\d+", "", dump)
        if steady == last:
            stable += 1
            if stable >= 2:
                return act
        else:
            last, stable = steady, 0
        time.sleep(0.5)
    if matched:
        return matched
    raise ProbeError(
        f"screen never settled on {expect!r}; foreground is "
        f"{resumed_activity(serial)!r}")


def start(serial: str, *, action: str = "", component: str = "", expect: str = "") -> str:
    """Start a settings screen and return the activity actually reached.

    The task is cleared first. Without that, starting a settings action while
    Settings is already open delivers the intent to the existing task and can
    leave an entirely different screen in front — `am` even says so, on a line
    nobody reads, and the walk then reads the wrong screen.
    """
    # FLAG_ACTIVITY_NEW_TASK | FLAG_ACTIVITY_CLEAR_TASK
    flags = ["-f", "0x10008000"]
    if component:
        _adb(serial, "shell", "am", "start", *flags, "-n", f"'{component}'")
    else:
        _adb(serial, "shell", "am", "start", *flags, "-a", action)
    return settle(serial, expect)


def home(serial: str) -> str:
    return start(serial, action="android.settings.SETTINGS", expect="SettingsHomepageActivity")


def read(serial: str, max_scrolls: int = 12) -> list[str]:
    """Every text on the screen, from the top to the bottom of the scroll."""
    for _ in range(5):                       # start from the top, wherever we were left
        _adb(serial, "shell", "input", "swipe", *SWIPE_DOWN)
        time.sleep(0.5)
    time.sleep(1.0)
    seen, last_len = [], -1
    for _ in range(max_scrolls):
        for t in _texts(ui_dump(serial)):
            if t not in seen:
                seen.append(t)
        if len(seen) == last_len:            # nothing new: the bottom is reached
            break
        last_len = len(seen)
        _adb(serial, "shell", "input", "swipe", *SWIPE_UP)
        time.sleep(0.8)
    return seen


def enter(serial: str, label: str, expect: str = "", scrolls: int = 12) -> str:
    """Scroll to an entry, tap it, and confirm where it led."""
    from runner import tap_text
    tap_text(serial, label, scrolls=scrolls)
    return settle(serial, expect)


def navigate(serial: str, *labels: str, expect: str = "") -> str:
    """Walk down the settings tree by tapping each label in turn.

    Many screens have no intent of their own — Private DNS, the theme picker,
    every leaf of a dashboard — so they can only be reached the way a user
    reaches them. Each tap is followed by waiting for the screen to change, so
    a label that was found but whose tap did nothing fails here rather than
    three assertions later.
    """
    from probes import resumed_activity
    before = resumed_activity(serial)
    for i, label in enumerate(labels):
        enter(serial, label, expect=expect if i == len(labels) - 1 else "")
        now = resumed_activity(serial)
        if now == before and i < len(labels) - 1:
            time.sleep(1.5)                   # same activity, new fragment: let it draw
        before = now
    return resumed_activity(serial)
