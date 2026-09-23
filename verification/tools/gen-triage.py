#!/usr/bin/env python3
"""Maintain verification/TRIAGE.md: the level of evidence each scenario can reach.

Deciding what could ever prove a scenario is a judgement, and it is worth making
once: without it every contributor re-derives the same decision, and nobody can
answer "how much of this is coverable at all?".

So the decision is recorded per scenario, keyed by its permanent identifier:

    @BRAND-2   observed    the version string is a property, reading it is enough
    @SETUP-4   measured    only walking the wizard shows the step is offered
    @PROC-1    repository  the merge is visible in the branch, not on a device
    @DEV-12    unreviewed  no judgement made yet

This tool **never overwrites a judgement**. It adds `unreviewed` lines for
scenarios that have none, drops nothing, and reports the counts. Editing the
levels is human work.

    python3 verification/tools/gen-triage.py          # report
    python3 verification/tools/gen-triage.py --write  # add the missing lines
"""
from __future__ import annotations

import collections
import glob
import os
import re
import sys

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REPO_ROOT = os.path.dirname(BASE)
TRIAGE = os.path.join(BASE, "TRIAGE.md")

LEVELS = {
    "measured": "only playing the scenario on the running application shows it",
    "observed": "querying the booted system is enough",
    "inspected": "reading the built image is enough",
    "repository": "provable against the repositories and the manifest, not the device",
    "unverifiable": "nothing can decide it mechanically",
    "unreviewed": "no judgement made yet",
}

SCENARIO_RE = re.compile(r"^\s*Scenario(?: Outline)?:\s*(.+?)\s*$")
TAG_LINE = re.compile(r"^\s*@[\w@ -]+\s*$")
ID_TAG = re.compile(r"@[A-Z]+-\d+\b")
ROW = re.compile(r"^\|\s*`(@[A-Z]+-\d+)`\s*\|\s*(\w+)\s*\|\s*(.*?)\s*\|")


def scenarios() -> dict[str, tuple[str, str]]:
    found = {}
    for path in sorted(glob.glob(os.path.join(REPO_ROOT, "features", "**", "*.feature"),
                                 recursive=True)):
        rel = os.path.relpath(path, REPO_ROOT)
        lines = open(path, errors="ignore").read().splitlines()
        for i, line in enumerate(lines):
            m = SCENARIO_RE.match(line)
            if not m:
                continue
            j, key = i - 1, None
            while j >= 0 and TAG_LINE.match(lines[j]):
                tag = ID_TAG.search(lines[j])
                if tag:
                    key = tag.group(0)
                j -= 1
            if key:
                found[key] = (rel, m.group(1))
    return found


def existing() -> dict[str, tuple[str, str]]:
    """identifier -> (level, note), from the file as it stands."""
    rows = {}
    if os.path.exists(TRIAGE):
        for line in open(TRIAGE, errors="ignore"):
            m = ROW.match(line)
            if m:
                rows[m.group(1)] = (m.group(2), m.group(3))
    return rows


def main(argv: list[str]) -> int:
    known = scenarios()
    rows = existing()

    unknown_level = {k: v for k, v in rows.items() if v[0] not in LEVELS}
    stale = sorted(set(rows) - set(known))
    missing = [k for k in known if k not in rows]

    if not (missing or "--write" in argv):
        counts = collections.Counter(v[0] for v in rows.values())
        print(" ".join(f"{lvl}={counts.get(lvl, 0)}" for lvl in LEVELS))
        if unknown_level:
            print(f"unknown level on: {', '.join(sorted(unknown_level))}", file=sys.stderr)
            return 1
        if stale:
            print(f"rows for scenarios that no longer exist: {', '.join(stale)}",
                  file=sys.stderr)
            return 1
        return 0

    if "--write" not in argv:
        print(f"{len(missing)} scenarios have no triage row; re-run with --write")
        return 0

    for key in missing:
        rows[key] = ("unreviewed", "")

    def sort_key(k: str):
        prefix, number = k[1:].split("-")
        return (prefix, int(number))

    counts = collections.Counter(v[0] for v in rows.values())
    out = [
        "# Triage: what could prove each scenario",
        "",
        "<!-- rows are added by verification/tools/gen-triage.py; the levels are"
        " written by hand and never overwritten by it -->",
        "",
        "Deciding what could ever prove a scenario is a judgement, worth making once.",
        "`unreviewed` means nobody has made it yet — it is not a level, it is a gap.",
        "",
        "| level | meaning | scenarios |",
        "|---|---|---|",
    ]
    for lvl, meaning in LEVELS.items():
        out.append(f"| `{lvl}` | {meaning} | {counts.get(lvl, 0)} |")
    out += ["", "| scenario | level | note |", "|---|---|---|"]
    for key in sorted(rows, key=sort_key):
        level, note = rows[key]
        out.append(f"| `{key}` | {level} | {note} |")

    with open(TRIAGE, "w") as fh:
        fh.write("\n".join(out) + "\n")
    print(f"{len(missing)} rows added, {len(rows)} total; "
          + " ".join(f"{lvl}={counts.get(lvl, 0)}" for lvl in LEVELS))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
