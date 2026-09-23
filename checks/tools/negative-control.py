#!/usr/bin/env python3
"""Run the delta-marked checks against a LineageOS build and report the passes.

A check that asserts /e/OS content must **fail** on a build with no /e/OS
content. One that passes there is asserting something Android or LineageOS
satisfies on its own — it will keep passing after the /e/OS change it claims to
verify has been lost, which is the failure mode a verification suite exists to
prevent.

The reference build cannot supply this: it is /e/OS too, so a check passing on
both says nothing. The control has to be a LineageOS image.

    python3 checks/tools/negative-control.py emulator-5558

Exits non-zero when any delta-marked check passes against it.
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print(__doc__.strip().splitlines()[-3].strip(), file=sys.stderr)
        return 2
    serial = argv[1]

    # Refuse a control that is itself /e/OS. Given one, every delta check would
    # pass and the report would read as a suite asserting nothing — the exact
    # misreading this tool exists to prevent.
    sys.path.insert(0, os.path.join(BASE, "tools"))
    from probes import ProbeError, packages, prop  # noqa: PLC0415
    try:
        eos_markers = [p for p in packages(serial) if p.startswith("foundation.e.")]
        legal = prop("ro.elegal.url", serial)
    except ProbeError as exc:
        print(f"cannot reach {serial}: {exc}", file=sys.stderr)
        return 2
    if eos_markers or legal:
        print(f"{serial} carries /e/OS content "
              f"({len(eos_markers)} foundation.e packages"
              f"{', ro.elegal.url is set' if legal else ''}).\n"
              f"The negative control must be a LineageOS build with no /e/OS content; "
              f"a previous /e/OS release is a *reference*, not a control.",
              file=sys.stderr)
        return 2

    with tempfile.TemporaryDirectory() as tmp:
        report = os.path.join(tmp, "report.json")
        subprocess.run(
            [sys.executable, "-m", "pytest", os.path.join(BASE, "device"),
             "-m", "delta", "--device", serial, "-q",
             "--tb=no", f"--junit-xml={report}.xml"],
            capture_output=True, text=True,
        )
        # Parse the JUnit report rather than the exit code: failures are the
        # expected outcome here, so the exit code carries no information.
        import xml.etree.ElementTree as ET
        try:
            root = ET.parse(f"{report}.xml").getroot()
        except (OSError, ET.ParseError):
            print("could not read the pytest report", file=sys.stderr)
            return 2

    passed, failed = [], []
    for case in root.iter("testcase"):
        name = f"{case.get('classname')}::{case.get('name')}"
        if case.find("failure") is not None or case.find("error") is not None:
            failed.append(name)
        elif case.find("skipped") is not None:
            continue
        else:
            passed.append(name)

    print(f"{len(failed)} delta checks correctly failed against {serial}")
    if passed:
        print(f"\n{len(passed)} passed, and should not have — they assert nothing "
              f"specific to /e/OS:")
        for name in passed:
            print(f"  - {name}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
