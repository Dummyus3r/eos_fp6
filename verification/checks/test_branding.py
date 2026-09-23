"""Checks for features/branding/identity.feature.

Worked example for the harness. What the device says about itself is settled at
build time, so most of this file is property comparison — the cheapest evidence
there is, and enough for a good part of that feature file.

Where the promise is "/e/OS decides this, not LineageOS", the check compares
against the a16 device rather than against a literal: a hardcoded
`== "Selenium.ogg"` would keep passing while meaning nothing the day the chosen
sound changes, whereas "the same value a16 ships" keeps stating the promise.

Scenarios of this file with no check here are listed in COVERAGE.md; the ones
about wallpapers need artefact probes on a built image, and the one about
LineageOS strings in the interface belongs to a journey, not to a property read.
"""
from __future__ import annotations

import os
import re
import sys

import pytest

sys.path.insert(
    0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "tools"))
from probes import packages, prop  # noqa: E402

from conftest import scenario  # noqa: E402


@scenario("features/branding/identity.feature::The build identifies itself as /e/OS")
def test_build_identifies_as_eos(a17):
    assert re.match(r"^\d+\.\d+-a17-", prop("ro.lineage.version", a17)), \
        "the version string should name the /e/OS release and the a17 generation"
    assert "e_emu64x" in prop("ro.build.description", a17), \
        "the build description should name the /e/OS product, not the LineageOS one"
    assert prop("ro.lineage.releasetype", a17), \
        "the version string should name a release type"


@scenario("features/branding/identity.feature::Wallpapers and sounds are /e/OS ones")
@pytest.mark.parametrize("key, expected", [
    ("ro.config.ringtone", "Dione.ogg"),
    ("ro.config.notification_sound", "Selenium.ogg"),
    ("ro.config.alarm_alert", "Platinum-old.ogg"),
])
def test_default_sounds(a17, a16, key, expected):
    """The scenario names the files, so assert them — and that a16 still agrees.

    The second assertion is what catches a port regression: a literal alone
    would also pass on a build where the /e/OS configuration never applied but
    the same default happened to be inherited.
    """
    assert prop(key, a17) == expected
    assert prop(key, a17) == prop(key, a16), \
        f"{key} differs from the a16 reference - the /e/OS value was lost in the port"


@scenario("features/branding/identity.feature::The emulator build identifies itself as /e/OS")
def test_emulator_product_identity(a17):
    assert prop("ro.product.name", a17) == "e_sdk_phone_x86_64"
    assert prop("ro.product.model", a17) == "/e/OS emulator x86_64"
    # The device suffix is the point of the scenario's comment: an empty
    # LINEAGE_BUILD silently drops it, and the envsetup guards that grep
    # ro.lineage.device then match any device.
    assert prop("ro.lineage.version", a17).endswith("-sdk_phone_x86_64"), \
        "the version string lost its device suffix - LINEAGE_BUILD is likely empty"
    assert prop("ro.lineage.device", a17), "ro.lineage.device should not be empty"


@scenario("features/branding/identity.feature::A running /e/OS emulator is distinguishable from a LineageOS one")
def test_emulator_is_distinguishable(a17, a16):
    assert prop("ro.product.name", a17) != prop("ro.product.name", a16), \
        "both emulators report the same product name - they cannot be told apart"
    assert prop("ro.product.name", a17) == "e_sdk_phone_x86_64"
    # PRODUCT_DEVICE comes from device/generic/goldfish, which /e/OS consumes
    # rather than forks, so this stays the same on both by design.
    assert prop("ro.product.device", a17) == prop("ro.product.device", a16) == "emu64x"


@scenario("features/branding/identity.feature::Boot")
def test_eos_applications_are_installed(a17):
    """Partial: the boot animation itself needs a capture, but a device that
    booted /e/OS carries the /e/OS application set."""
    installed = packages(a17)
    missing = {p for p in (
        "foundation.e.advancedprivacy",
        "foundation.e.accountmanager",
    ) if p not in installed}
    assert not missing, f"missing /e/OS packages: {sorted(missing)}"
