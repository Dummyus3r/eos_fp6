"""pytest wiring for the verification checks.

`@scenario(...)` is a thin alias over a pytest marker: it carries the link to
the specification and nothing else. Keeping it a marker rather than inventing a
format means selection, reporting, JUnit output and parallelism come from
pytest instead of being rebuilt.

Devices are addressed by **role**, never by generation:

* `device`    — the build under test;
* `reference` — a previous /e/OS build, for checks whose promise is "/e/OS
  decides this", where comparing beats a literal;
* `lineage`   — a LineageOS build with no /e/OS content, the negative control.

Naming the fixtures after roles rather than after a16/a17 is deliberate: the
suite has to survive the next generation without being rewritten, and a run
that puts the older build under test should not read as `a17 = <the a16
device>`.

    pytest verification/checks --device emulator-5556 --reference emulator-5554
"""
from __future__ import annotations

import os
import sys

import pytest

_HERE = os.path.dirname(os.path.abspath(__file__))
# tools/ holds the probes, journeys/ the walk; both are imported by test modules
# in either subfolder, and this conftest sits above both so the options and
# fixtures are seen from each.
for _d in (_HERE, os.path.join(_HERE, "tools"), os.path.join(_HERE, "journeys")):
    if _d not in sys.path:
        sys.path.insert(0, _d)


def pytest_addoption(parser):
    parser.addoption("--device", default="", help="serial of the build under test")
    parser.addoption("--reference", default="",
                     help="serial of a previous /e/OS build, used as a reference")
    parser.addoption("--lineage", default="",
                     help="serial of a LineageOS build, used as the negative control")
    parser.addoption("--product-out", default="",
                     help="path to out/target/product/<device> for artefact checks")


def pytest_configure(config):
    config.addinivalue_line(
        "markers", "scenario(key): the features/ scenario this check verifies")
    config.addinivalue_line(
        "markers", "delta: asserts /e/OS content, so it must fail on a LineageOS build")
    config.addinivalue_line(
        "markers", "evidence(level): measured, observed or inspected")


def _scenario_titles() -> dict[str, str]:
    """identifier -> scenario title, read from features/ at collection time."""
    import glob
    import re
    root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    scenario_re = re.compile(r"^\s*Scenario(?: Outline)?:\s*(.+?)\s*$")
    tag_re = re.compile(r"^\s*@[\w@ -]+\s*$")
    id_re = re.compile(r"@[A-Z]+-\d+\b")
    titles = {}
    for path in glob.glob(os.path.join(root, "features", "**", "*.feature"), recursive=True):
        lines = open(path, errors="ignore").read().splitlines()
        for i, line in enumerate(lines):
            m = scenario_re.match(line)
            if not m:
                continue
            j, key = i - 1, None
            while j >= 0 and tag_re.match(lines[j]):
                found = id_re.search(lines[j])
                if found:
                    key = found.group(0)
                j -= 1
            if key:
                titles[key] = m.group(1)
    return titles


def pytest_collection_modifyitems(items):
    """Report a check under the scenario it verifies, not under its function name.

    The JUnit report is what a reviewer reads in CI, and
    `test_build_identifies_as_eos` says less there than the identifier and the
    sentence from the specification. Both are shown: the identifier is what one
    cites, the title is what makes the report readable without opening
    `features/`.
    """
    titles = _scenario_titles()
    for item in items:
        marker = item.get_closest_marker("scenario")
        if not marker or not marker.args:
            continue
        key = marker.args[0]
        label = f"{key} {titles[key]}" if key in titles else key
        params = item.name[len(item.originalname):] if hasattr(item, "originalname") else ""
        item._nodeid = f"{item.nodeid.split('::')[0]}::{label}{params}"


def _serial(request, option: str, why: str) -> str:
    serial = request.config.getoption(option)
    if not serial:
        pytest.skip(f"no {option} given ({why})")
    return serial


@pytest.fixture(scope="session")
def device(request):
    return _serial(request, "--device", "the build under test")


@pytest.fixture(scope="session")
def reference(request):
    return _serial(request, "--reference", "a previous /e/OS build to compare against")


@pytest.fixture(scope="session")
def product_out(request):
    path = request.config.getoption("--product-out")
    if not path:
        pytest.skip("no --product-out given (artefact checks need a built image)")
    return path


def scenario(key: str):
    """Mark a check as verifying the scenario with this identifier, e.g. `@BRAND-2`.

    The identifier, not the path and title: it survives the scenario being
    renamed or moved, which a path does not, and three scenario titles collide
    across the corpus.
    """
    return pytest.mark.scenario(key)


def evidence(level: str):
    """How strongly this check proves its scenario.

    * `measured`  — the scenario was played on the running application. This is
      what proves it: a patch can be green at build time and have no effect at
      runtime, and that is exactly what the other two levels miss.
    * `observed`  — the running system was queried, but the scenario was not
      played. Reading `ro.config.ringtone` says the value is in the image; it
      does not say a ringtone plays.
    * `inspected` — the build was read, nothing ran. Fast feedback, weakest
      evidence.

    Only `measured` counts as proven in COVERAGE.md. The other two are reported
    so that the difference between "checked" and "proven" stays visible instead
    of being flattened into one number.
    """
    assert level in {"measured", "observed", "inspected"}, level
    return pytest.mark.evidence(level)


#: Marks a check that asserts /e/OS content rather than a property Android
#: would satisfy on its own. `verification/tools/negative-control.py` runs every
#: check carrying it against a LineageOS build and reports the ones that pass —
#: a check that passes there is asserting nothing about /e/OS.
delta = pytest.mark.delta
