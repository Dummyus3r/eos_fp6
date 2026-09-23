"""pytest wiring for the verification checks.

`@scenario(...)` is a thin alias over a pytest marker: it carries the link to
the specification and nothing else. Keeping it a marker rather than inventing a
format means selection, reporting, JUnit output and parallelism come from
pytest instead of being rebuilt.

Two devices are addressed by role rather than by serial, so a check reads
`prop("ro.config.ringtone", A17)` and the serials stay in one place:

    pytest --a17 emulator-5556 --a16 emulator-5554
"""
from __future__ import annotations

import pytest

A16 = "a16"
A17 = "a17"


def pytest_addoption(parser):
    parser.addoption("--a17", default="", help="serial of the a17 device under test")
    parser.addoption("--a16", default="", help="serial of the a16 reference device")
    parser.addoption("--product-out", default="",
                     help="path to out/target/product/<device> for artefact checks")


def pytest_configure(config):
    config.addinivalue_line(
        "markers", "scenario(key): the features/ scenario this check verifies")


@pytest.fixture(scope="session")
def a17(request):
    serial = request.config.getoption("--a17")
    if not serial:
        pytest.skip("no --a17 device given")
    return serial


@pytest.fixture(scope="session")
def a16(request):
    """The a16 device, as a reference. Checks that compare against it skip without one."""
    serial = request.config.getoption("--a16")
    if not serial:
        pytest.skip("no --a16 reference device given")
    return serial


@pytest.fixture(scope="session")
def product_out(request):
    path = request.config.getoption("--product-out")
    if not path:
        pytest.skip("no --product-out given")
    return path


def scenario(key: str):
    """Mark a check as verifying `<features path>::<Scenario title>`."""
    return pytest.mark.scenario(key)
