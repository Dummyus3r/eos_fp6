"""The journey model: walking a flow and asserting along the way.

A journey is not a set of independent tests. It is stateful and ordered — you
cannot assert "a parental control step is offered" without traversing what
precedes it — so it is modelled as a walk, and the *sequence it traverses* is
itself the main assertion.

That is the part worth having. A step wired into a flow nothing reaches will
compile, will read correctly in `lineage_wizard_script.xml`, and will never be
shown; only walking the flow reveals it. The runner records the screens it
actually met, so a missing step reports as "not traversed" rather than as an
opaque failure somewhere downstream.

Two rules keep a journey from rotting:

* **recognise, never assume.** A screen is identified by its resumed activity
  and an optional marker in the hierarchy, never by coordinates from a previous
  run — those change with density and locale.
* **a screen may be conditional.** Steps that appear only on some devices are
  declared optional with a predicate, instead of hidden in an `if` inside the
  walk.
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Callable

from probes import ProbeError, resumed_activity, ui_dump


@dataclass(frozen=True)
class Screen:
    """One step of a flow, able to recognise itself."""

    activity: str
    """Substring of the resumed component, e.g. '.WelcomeActivity'."""

    marker: str | None = None
    """Text or resource-id that must be present. None for a FLAG_SECURE screen,
    whose hierarchy Android refuses to dump — there, the activity is all the
    evidence available."""

    scenarios: tuple[str, ...] = ()
    """The features/ scenarios this screen carries, as `<path>::<title>`."""

    optional: bool = False
    """Whether the flow may legitimately skip this screen."""

    applies: Callable[[str], bool] | None = None
    """Predicate on the serial: whether this screen is expected on this device."""

    next_label: str | None = None
    """Text of the control that leaves this screen, located at run time. None
    means the walk stops here — the last screen of a journey, or one whose exit
    needs an action the journey declares itself."""

    def leave(self, serial: str) -> None:
        from runner import tap_text
        if self.next_label is None:
            raise NotImplementedError(f"{self.activity} declares no way out")
        tap_text(serial, self.next_label)

    def matches(self, serial: str) -> bool:
        try:
            if self.activity not in resumed_activity(serial):
                return False
        except ProbeError:
            return False
        if self.marker is None:
            return True
        return self.marker in ui_dump(serial)


@dataclass
class Journey:
    """An expected sequence of screens, and what the walk actually met."""

    name: str
    screens: list[Screen]
    traversed: list[str] = field(default_factory=list)
    missing: list[str] = field(default_factory=list)
    unexpected: list[str] = field(default_factory=list)

    def compare(self, other: "Journey") -> dict[str, list[str]]:
        """Differences between two walks of the same journey.

        Running the same journey on the a16 reference and on a17 turns the two
        traversals into a diff: steps a16 shows and a17 does not are either an
        upstream restructuring or an /e/OS step lost in the port, and the
        distinction is a judgement call — which is why this reports rather than
        asserts.
        """
        mine, theirs = self.traversed, other.traversed
        return {
            "only_here": [s for s in mine if s not in theirs],
            "only_there": [s for s in theirs if s not in mine],
        }


def tap_text(serial: str, label: str) -> None:
    """Tap the centre of the node whose text is `label`, located at run time."""
    dump = ui_dump(serial)
    pattern = (r'text="' + re.escape(label) + r'"[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"')
    m = re.search(pattern, dump)
    if not m:
        raise ProbeError(f'no node labelled "{label}" on the current screen')
    x1, y1, x2, y2 = (int(g) for g in m.groups())
    from probes import _adb  # noqa: PLC0415 - internal on purpose
    _adb(serial, "shell", "input", "tap", str((x1 + x2) // 2), str((y1 + y2) // 2))
