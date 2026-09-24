"""Journeys through the Settings tree.

Unlike the first-boot wizard, these are short walks: open a screen, act, and
check where the device ended up. They are still journeys rather than device
queries, because what they assert is *what the running application does when
the user touches it* — an entry that exists in the hierarchy but leads nowhere
would satisfy a query and fail here.

Two surfaces of this build cannot be walked, and it is worth saying why rather
than discovering it again. `uiautomator dump` captures a window only once it
goes idle, and it gives up with `could not get idle state` otherwise:

* **the launcher** renders continuously — around sixty frames a second with
  nothing happening — so its hierarchy can never be captured;
* **About phone** (`Settings$MyDeviceInfoActivity`) never settles either, on
  both a16 and a17, from a freshly started process.

Scenarios living on those two surfaces therefore cannot be measured this way,
whatever the patience — `@SYS-43` and `@SYS-44` on *About phone*, the eight
notification-badge scenarios on the launcher. They are left uncovered rather
than checked against something weaker, and `DECISIONS.md` records why, so the
gap is a recorded constraint instead of an oversight.
"""
from __future__ import annotations

import re
import time

import settings
from probes import ProbeError, ui_dump, _adb


def homepage(serial: str) -> str:
    """The settings home page, from a freshly started process.

    Force-stopping first is not hygiene, it is correctness: starting a settings
    action while Settings is already open delivers the intent into the existing
    task, which can leave a completely different screen in front.
    """
    _adb(serial, "shell", "am", "force-stop", "com.android.settings")
    time.sleep(1.0)
    return settings.home(serial)


def open_entry(serial: str, label: str, expect: str) -> str:
    """Tap a home page entry and return the activity it opened."""
    homepage(serial)
    return settings.enter(serial, label, expect=expect)


def search(serial: str, term: str) -> list[str]:
    """Type a term into the settings search bar and read every result.

    `input text` splits on spaces and would type only the first word; the
    device's own escape for a space is `%s`. And the results are read by
    scrolling to the bottom — a result that is merely below the fold would
    otherwise read as absent, which is how a check comes to report a defect
    that is not there.
    """
    homepage(serial)
    dump = ui_dump(serial)
    m = re.search(r'resource-id="com\.android\.settings:id/search_[^"]*"'
                  r'[^>]*bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"', dump)
    if not m:
        raise ProbeError("no search bar on the settings home page")
    x1, y1, x2, y2 = (int(g) for g in m.groups())
    _adb(serial, "shell", "input", "tap", str((x1 + x2) // 2), str((y1 + y2) // 2))
    time.sleep(2.0)
    _adb(serial, "shell", "input", "text", term.replace(" ", "%s"))
    time.sleep(3.0)
    return settings.read(serial)


def private_dns(serial: str) -> list[str]:
    """The Private DNS dialog, reached the way a user reaches it.

    It has no intent of its own, so it is only reachable by walking
    *Network & internet* and tapping the entry.
    """
    homepage(serial)
    settings.navigate(serial, "Network & internet", "Private DNS")
    return settings.read(serial)


def developer_options(serial: str) -> list[str]:
    """Every entry of the developer options, in the order they are listed.

    The order is the point for `@PRIV-32`: what is asserted is not that the
    /e/OS entries exist but that they are gathered, and only a sequence can
    show that.
    """
    settings.start(serial, action="android.settings.APPLICATION_DEVELOPMENT_SETTINGS")
    return settings.read(serial, max_scrolls=40)


def search_and_open(serial: str, term: str, label: str, expect: str = "") -> str:
    """Search the settings for a term, tap a result, and return where it led.

    The settings search is a first-class way into the tree, and for an entry
    that lives several screens deep it is the way a user actually gets there.
    It also covers the whole tree, where walking covers only the path walked.
    """
    search(serial, term)
    return settings.enter(serial, label, expect=expect)
