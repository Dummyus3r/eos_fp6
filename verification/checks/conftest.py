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

sys.path.insert(
    0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "tools"))


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
    """Mark a check as verifying `<features path>::<Scenario title>`."""
    return pytest.mark.scenario(key)


#: Marks a check that asserts /e/OS content rather than a property Android
#: would satisfy on its own. `verification/tools/negative-control.py` runs every
#: check carrying it against a LineageOS build and reports the ones that pass —
#: a check that passes there is asserting nothing about /e/OS.
delta = pytest.mark.delta
