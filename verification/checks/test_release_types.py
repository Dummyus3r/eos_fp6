"""Checks for features/updates/release-types.feature.

The release type and the version string are pure build-time composition, so
they are readable from properties alone. The scenarios about what the updater
*asks for* need the updater running and belong to a journey.
"""
from __future__ import annotations

import re

from probes import prop
from conftest import delta, scenario

#: 4.3-a17-20260921-UNOFFICIAL-sdk_phone_x86_64
#: major.minor[.maintenance]-<generation>-<date>[<pipeline>]-<type>[-<extra>]-<device>
VERSION = re.compile(
    r"^(?P<major>\d+)\.(?P<minor>\d+)(?:\.(?P<maintenance>\d+))?"
    r"-(?P<generation>a\d+)"
    r"-(?P<date>\d{8})(?P<pipeline>\d*)"
    r"-(?P<type>[A-Za-z]+)"
    r"(?P<extra>-.+?)??"
    r"-(?P<device>[a-z0-9_]+)$"
)


def parsed(device):
    version = prop("ro.lineage.version", device)
    m = VERSION.match(version)
    assert m, f"version string does not parse: {version!r}"
    return m


@delta
@scenario("features/updates/release-types.feature::The version carries the /e/OS version, the Android generation and the build")
def test_version_string_composition(device):
    m = parsed(device)
    assert f"{m['major']}.{m['minor']}" == prop("ro.lineage.build.version", device), \
        "the version string and ro.lineage.build.version disagree on the /e/OS version"
    assert m["generation"] == "a17", "the version string should name the Android generation"
    assert m["date"], "the version string should carry the build date"
    assert m["type"], "the version string should carry the release type"
    # The suffix is LINEAGE_BUILD, derived from the product name, not
    # PRODUCT_DEVICE - they coincide on a real device, where the product is
    # lineage_<device>, and legitimately differ on the emulator. What matters
    # is that the suffix is there at all: an empty LINEAGE_BUILD drops it, and
    # the envsetup guards that grep ro.lineage.device then match any device.
    expected_build = re.sub(r"^(e|lineage)_", "", prop("ro.product.name", device))
    assert m["device"] == expected_build, \
        "the version suffix does not match LINEAGE_BUILD derived from the product name"


@scenario("features/updates/release-types.feature::An unofficial build can still be identified")
def test_unofficial_build_is_identified(device):
    release_type = prop("ro.lineage.releasetype", device)
    assert release_type, "a build with no release type cannot be identified"
    assert release_type in prop("ro.lineage.version", device), \
        "the release type should appear in the version string"


@scenario("features/updates/release-types.feature::A build can be traced back to the pipeline that produced it")
def test_pipeline_identifier(device):
    """A locally built image has no pipeline, and that is not a defect.

    The scenario is given a build produced by the pipeline; asserting the
    identifier unconditionally would fail on every developer build, so the
    check states the implication instead: when there is one, it is traceable.
    """
    pipeline = prop("ro.cm.build.pipeline.id", device)
    if not pipeline:
        import pytest
        pytest.skip("locally built image - no pipeline produced it")
    assert pipeline in prop("ro.lineage.version", device), \
        "the pipeline identifier should appear in the version string"


@delta
@scenario("features/updates/release-types.feature::A LineageOS release type is not recognised")
def test_release_type_is_not_a_lineage_one(device):
    """/e/OS has its own release-type vocabulary; a LineageOS one means the
    /e/OS configuration did not apply."""
    assert prop("ro.lineage.releasetype", device).lower() not in {
        "nightly", "weekly", "experimental", "snapshot",
    }, "the build carries a LineageOS release type"
