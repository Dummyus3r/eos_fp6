#!/usr/bin/env python3
"""Generate checks/COVERAGE.md by crossing features/ scenarios with the checks.

A check names the scenario it verifies by its permanent identifier, in a
`@scenario("@BRAND-2")` marker, and says how strongly it proves it in an
`@evidence(...)` one. Nothing else records the link: no mapping file to keep in
sync, no test identifier injected into the specification.

**Only `measured` counts as proven.** A patch can be green at build time and
have no effect at runtime; a scenario is proven when it has been played on the
running application, not when a property read agrees with it. The weaker levels
are reported rather than hidden, because they are useful feedback — they are
just not proof.

The report is bidirectional, because both directions are defects:

* a scenario no check names is unverified;
* a check naming an identifier no scenario carries is orphaned — either a typo,
  or a scenario that was deleted while the check was left behind.

    python3 checks/tools/gen-coverage.py

Exits non-zero on an orphaned check or an unreadable marker, so this runs as a
CI gate and not only as a report.
"""
from __future__ import annotations

import datetime
import glob
import os
import re
import sys

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REPO_ROOT = os.path.dirname(BASE)

SCENARIO_RE = re.compile(r"^(\s*)Scenario(?: Outline)?:\s*(.+?)\s*$")
TAG_LINE = re.compile(r"^\s*@[\w@ -]+\s*$")
ID_TAG = re.compile(r"@[A-Z]+-\d+\b")
MARKER_RE = re.compile(r'@scenario\(\s*["\'](?P<key>@[A-Z]+-\d+)["\']')
ANY_MARKER_RE = re.compile(r"@scenario\(")
EVIDENCE_RE = re.compile(r'@evidence\(\s*["\'](?P<level>\w+)["\']')

LEVELS = ("measured", "observed", "inspected")


def scenarios() -> dict[str, tuple[str, str]]:
    """identifier -> (features path, scenario title)."""
    found = {}
    pattern = os.path.join(REPO_ROOT, "features", "**", "*.feature")
    for path in sorted(glob.glob(pattern, recursive=True)):
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
                found[key] = (rel, m.group(2))
    return found


def claimed() -> tuple[dict[str, list[tuple[str, str]]], list[str]]:
    """identifier -> [(check path, evidence level)], plus markers that could not be read."""
    found: dict[str, list[tuple[str, str]]] = {}
    unreadable: list[str] = []
    for folder in ("device", "journeys"):
        for path in sorted(glob.glob(os.path.join(BASE, folder, "**", "*.py"), recursive=True)):
            if os.path.basename(path) == "conftest.py":
                continue   # defines the markers, does not use them
            rel = os.path.relpath(path, REPO_ROOT)
            text = open(path, errors="ignore").read()
            # The evidence marker belongs to the same decorator block as the
            # scenario marker, and may sit on either side of it. Searching
            # backwards through the whole file instead — as this did — reads the
            # *previous* check's level whenever the two decorators are written in
            # the other order, and reports a level that is right only by luck.
            lines = text.splitlines()
            for m in MARKER_RE.finditer(text):
                line_no = text[:m.start()].count("\n")
                start = line_no
                while start > 0 and lines[start - 1].lstrip().startswith("@"):
                    start -= 1
                end = line_no
                while end + 1 < len(lines) and lines[end + 1].lstrip().startswith("@"):
                    end += 1
                block = "\n".join(lines[start:end + 1])
                ev = EVIDENCE_RE.findall(block)
                level = ev[-1] if ev else "observed"
                found.setdefault(m.group("key"), []).append((rel, level))
            missed = len(ANY_MARKER_RE.findall(text)) - len(MARKER_RE.findall(text))
            if missed > 0:
                unreadable.append(f"{rel}: {missed} marker(s) not a plain identifier literal")
    return found, unreadable


def main() -> int:
    known = scenarios()
    named, unreadable = claimed()

    orphaned = {k: v for k, v in named.items() if k not in known}
    by_level: dict[str, set[str]] = {lvl: set() for lvl in LEVELS}
    for key, entries in named.items():
        if key not in known:
            continue
        for _path, level in entries:
            by_level.setdefault(level, set()).add(key)

    proven = by_level["measured"]
    weaker = (by_level["observed"] | by_level["inspected"]) - proven
    untouched = sorted(set(known) - set(named))

    lines = [
        "# Check coverage",
        "",
        f"<!-- generated by checks/tools/gen-coverage.py on "
        f"{datetime.date.today().isoformat()} - do not edit by hand -->",
        "",
        f"**{len(proven)} of {len(known)} scenarios are proven** — played on the "
        f"running application.",
        "",
        f"{len(weaker)} more are checked without being proven: the running system "
        f"was queried, or the build was read, but the scenario itself was not "
        f"played. A patch can be green at build time and have no effect at "
        f"runtime, which is exactly what those levels miss. They are useful "
        f"feedback and they are not proof, so they are counted apart rather than "
        f"folded into one number.",
        "",
        "| level | scenarios | what it means |",
        "|---|---|---|",
        f"| measured | {len(by_level['measured'])} | the scenario was played on the running application |",
        f"| observed | {len(by_level['observed'])} | the running system was queried, the scenario was not played |",
        f"| inspected | {len(by_level['inspected'])} | the build was read, nothing ran |",
        f"| none | {len(untouched)} | no check names this scenario |",
    ]

    if weaker:
        lines += ["", "## Checked, not proven", "",
                  "| scenario | title | level |", "|---|---|---|"]
        for key in sorted(weaker):
            path, title = known[key]
            level = ", ".join(sorted({lvl for _p, lvl in named[key]}))
            lines.append(f"| `{key}` | {title} | {level} |")

    if orphaned:
        lines += ["", "## Orphaned checks", "",
                  "These name an identifier no scenario carries — a typo, or a scenario "
                  "deleted while its check was left behind.", ""]
        for key, entries in sorted(orphaned.items()):
            where = ", ".join(f"`{p}`" for p, _lvl in entries)
            lines.append(f"- `{key}` named by {where}")

    if unreadable:
        lines += ["", "## Markers that could not be read", "",
                  "`@scenario(...)` must take a plain identifier literal: the report is "
                  "extracted statically, and an f-string would understate coverage "
                  "rather than fail.", ""]
        lines += [f"- {item}" for item in unreadable]

    if untouched:
        lines += ["", "## Not verified yet", "",
                  "Some of these have no device-level evidence at all — they state a "
                  "promise about how the port is carried out rather than about the "
                  "device. They are listed so that the choice not to verify them stays "
                  "visible.", "",
                  "| scenario | file | title |", "|---|---|---|"]
        for key in untouched:
            path, title = known[key]
            lines.append(f"| `{key}` | `{path}` | {title} |")

    out = os.path.join(BASE, "COVERAGE.md")
    with open(out, "w") as fh:
        fh.write("\n".join(lines) + "\n")

    print(f"{len(proven)} proven, {len(weaker)} checked but not proven, "
          f"{len(untouched)} untouched, {len(orphaned)} orphaned, "
          f"{len(unreadable)} unreadable -> {os.path.relpath(out, REPO_ROOT)}")
    return 1 if (orphaned or unreadable) else 0


if __name__ == "__main__":
    sys.exit(main())
