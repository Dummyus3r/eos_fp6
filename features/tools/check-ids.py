#!/usr/bin/env python3
"""Check that scenario identifiers are present, unique, and never reused.

The identifier is what a test, a merge request or a verdict cites, so its
guarantees have to be enforced rather than trusted:

* every scenario carries exactly one;
* no two scenarios carry the same one;
* a number recorded in the registry is never given to a different scenario,
  even after the one it named is deleted — a citation must keep resolving to
  what it meant.

    python3 features/tools/check-ids.py

Exits non-zero on any of those, so it runs as a CI gate.
"""
from __future__ import annotations

import os
import sys
# assign-ids.py cannot be imported under a name containing a dash, so the small
# amount of parsing the two share is duplicated rather than the file renamed:
# its name is referenced from the README and from CI.
import glob
import re

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REPO_ROOT = os.path.dirname(BASE)
REGISTRY = os.path.join(BASE, "IDS.md")

SCENARIO = re.compile(r"^(\s*)Scenario(?: Outline)?:\s*(.+?)\s*$")
TAG_LINE = re.compile(r"^\s*@[\w@ -]+\s*$")
ID_TAG = re.compile(r"@[A-Z]+-\d+\b")


def scan():
    for path in sorted(glob.glob(os.path.join(BASE, "**", "*.feature"), recursive=True)):
        lines = open(path, errors="ignore").read().splitlines()
        for i, line in enumerate(lines):
            m = SCENARIO.match(line)
            if not m:
                continue
            ids, j = [], i - 1
            while j >= 0 and TAG_LINE.match(lines[j]):
                ids += ID_TAG.findall(lines[j])
                j -= 1
            yield os.path.relpath(path, REPO_ROOT), m.group(2), ids


def registry() -> dict[str, str]:
    assigned = {}
    if os.path.exists(REGISTRY):
        for line in open(REGISTRY, errors="ignore"):
            m = re.match(r"^\| `(@[A-Z]+-\d+)` \| (.+?) \|", line)
            if m:
                assigned[m.group(1)] = m.group(2)
    return assigned


def main() -> int:
    problems: list[str] = []
    seen: dict[str, tuple[str, str]] = {}

    for path, title, ids in scan():
        if not ids:
            problems.append(f"{path} :: {title} — carries no identifier")
            continue
        if len(ids) > 1:
            problems.append(f"{path} :: {title} — carries several: {', '.join(ids)}")
            continue
        key = ids[0]
        if key in seen:
            other = seen[key]
            problems.append(
                f"{key} is on two scenarios: {other[0]} :: {other[1]} and {path} :: {title}")
        seen[key] = (path, title)

    known = registry()
    for key, (path, title) in seen.items():
        if key not in known:
            problems.append(f"{key} is used by {path} :: {title} but is not in the registry — "
                            f"re-run features/tools/assign-ids.py --write")

    if problems:
        print(f"{len(problems)} problem(s):")
        for p in problems:
            print(f"  - {p}")
        return 1

    print(f"{len(seen)} scenarios, each with a unique identifier, all in the registry")
    return 0


if __name__ == "__main__":
    sys.exit(main())
