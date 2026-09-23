#!/usr/bin/env python3
"""Report the scenarios actually proven, by crossing the JUnit report with the claims.

`gen-coverage.py` reads the source and reports what each check *claims* to
verify and at what level. That is a static reading, and a claim is not a proof:
a check marked `measured` that fails, errors or is skipped has proven nothing.

This crosses the claims with a run. Only a scenario whose `measured` check
actually passed is counted as proven.

    pytest verification --device <serial> --junit-xml=report.xml
    python3 verification/tools/proven.py report.xml

Exits non-zero if any scenario is claimed proven but its check did not pass.
"""
from __future__ import annotations

import os
import re
import sys
import xml.etree.ElementTree as ET

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

ID_IN_NAME = re.compile(r"(@[A-Z]+-\d+)")
MARKER = re.compile(r'@scenario\(\s*["\'](@[A-Z]+-\d+)["\']')
EVIDENCE = re.compile(r'@evidence\(\s*["\'](\w+)["\']')


def claims() -> dict[str, str]:
    """identifier -> the strongest level any check claims for it."""
    rank = {"inspected": 1, "observed": 2, "measured": 3}
    best: dict[str, str] = {}
    import glob
    for folder in ("checks", "journeys"):
        for path in glob.glob(os.path.join(BASE, folder, "**", "*.py"), recursive=True):
            if os.path.basename(path) == "conftest.py":
                continue
            text = open(path, errors="ignore").read()
            for m in MARKER.finditer(text):
                levels = EVIDENCE.findall(text[:m.start()])
                level = levels[-1] if levels else "observed"
                key = m.group(1)
                if rank.get(level, 0) > rank.get(best.get(key, ""), 0):
                    best[key] = level
    return best


def outcomes(report: str) -> dict[str, set[str]]:
    """identifier -> the set of outcomes its checks had in this run."""
    root = ET.parse(report).getroot()
    found: dict[str, set[str]] = {}
    for case in root.iter("testcase"):
        m = ID_IN_NAME.search(case.get("name") or "")
        if not m:
            continue
        if case.find("failure") is not None or case.find("error") is not None:
            outcome = "failed"
        elif case.find("skipped") is not None:
            outcome = "skipped"
        else:
            outcome = "passed"
        found.setdefault(m.group(1), set()).add(outcome)
    return found


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: proven.py <junit report.xml>", file=sys.stderr)
        return 2
    claimed, ran = claims(), outcomes(argv[1])

    proven, unproven = [], []
    for key, level in sorted(claimed.items()):
        if level != "measured":
            continue
        result = ran.get(key, set())
        if result == {"passed"}:
            proven.append(key)
        else:
            unproven.append((key, ", ".join(sorted(result)) or "did not run"))

    weaker = sorted(k for k, lvl in claimed.items()
                    if lvl != "measured" and ran.get(k) == {"passed"})

    print(f"proven: {len(proven)} scenario(s) measured on the running application "
          f"and passing")
    for key in proven:
        print(f"  {key}")
    print(f"checked but not proven: {len(weaker)}")
    if unproven:
        print(f"\nclaimed measured but not passing: {len(unproven)}")
        for key, why in unproven:
            print(f"  {key}: {why}")
    return 1 if unproven else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
