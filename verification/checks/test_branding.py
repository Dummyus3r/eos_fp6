"""Checks for features/branding/identity.feature.

What the device says about itself is settled at build time, so most of this
file is property comparison — the cheapest evidence there is, and enough for a
good part of that feature file.

Scenarios of this file with no check here are listed in COVERAGE.md: the
wallpaper ones need artefact probes on a built image, and "No LineageOS string
is left in the user interface" belongs to a journey, not to a property read.
"""
from __future__ import annotations

import re

import pytest

from probes import packages, prop
from conftest import delta, evidence, scenario

FEATURE = "features/branding/identity.feature"


@delta
@evidence("observed")
@scenario("@BRAND-2")
def test_build_identifies_as_eos(device):
    assert re.match(r"^\d+\.\d+.*-a17-", prop("ro.lineage.version", device)), \
        "the version string should name the /e/OS release and the Android generation"
    assert "e_emu64x" in prop("ro.build.description", device), \
        "the build description should name the /e/OS product, not the LineageOS one"
    assert prop("ro.lineage.releasetype", device), \
        "the version string should name a release type"


@delta
@evidence("observed")
@scenario("@BRAND-3")
@pytest.mark.parametrize("key, expected", [
    ("ro.config.ringtone", "Dione.ogg"),
    ("ro.config.notification_sound", "Selenium.ogg"),
    ("ro.config.alarm_alert", "Platinum-old.ogg"),
])
def test_default_sounds(device, key, expected):
    assert prop(key, device) == expected


@evidence("observed")
@scenario("@BRAND-3")
@pytest.mark.parametrize("key", [
    "ro.config.ringtone",
    "ro.config.notification_sound",
    "ro.config.alarm_alert",
])
def test_default_sounds_survived_the_port(device, reference, key):
    """The literal above says what the value is; this says it was not lost.

    A literal alone would also pass on a build where the /e/OS configuration
    never applied but the same default happened to be inherited.
    """
    assert prop(key, device) == prop(key, reference), \
        f"{key} differs from the reference build - the /e/OS value was lost in the port"


@delta
@evidence("observed")
@scenario("@BRAND-6")
def test_emulator_product_identity(device):
    assert prop("ro.product.name", device) == "e_sdk_phone_x86_64"
    assert prop("ro.product.model", device) == "/e/OS emulator x86_64"
    # The device suffix is the point of the scenario's comment: an empty
    # LINEAGE_BUILD silently drops it, and the envsetup guards that grep
    # ro.lineage.device then match any device.
    assert prop("ro.lineage.version", device).endswith("-sdk_phone_x86_64"), \
        "the version string lost its device suffix - LINEAGE_BUILD is likely empty"
    assert prop("ro.lineage.device", device), "ro.lineage.device should not be empty"


@delta
@evidence("observed")
@scenario("@BRAND-7")
def test_emulator_is_distinguishable(device, reference):
    assert prop("ro.product.name", device) == "e_sdk_phone_x86_64"
    assert prop("ro.product.name", device) != prop("ro.product.name", reference) \
        or prop("ro.lineage.version", device) != prop("ro.lineage.version", reference), \
        "the two builds are indistinguishable from the host"
    # PRODUCT_DEVICE comes from device/generic/goldfish, which /e/OS consumes
    # rather than forks, so this stays the same across builds by design.
    assert prop("ro.product.device", device) == "emu64x"


@delta
@evidence("observed")
@scenario("@BRAND-1")
def test_eos_applications_are_installed(device):
    """Partial: the boot animation itself needs a capture, but a device that
    booted /e/OS carries the /e/OS application set."""
    installed = packages(device)
    missing = {p for p in (
        "foundation.e.advancedprivacy",
        "foundation.e.accountmanager",
    ) if p not in installed}
    assert not missing, f"missing /e/OS packages: {sorted(missing)}"
