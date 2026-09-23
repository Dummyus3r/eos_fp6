"""Run the first-boot journey and report what it traversed.

This is the only level that proves a scenario: a step can be wired into the
wizard, compile, read correctly in the wizard script and never be shown. The
walk is what notices.

The device has to be at the start of the wizard. It is not wiped from here —
doing so from inside a test would make a failure indistinguishable from a
device that was simply in the wrong state:

    adb -s <serial> emu kill
    run-emulator.sh <tree> <combo> <port> -wipe-data
"""
from __future__ import annotations

import os

import pytest

from conftest import evidence, scenario
from first_boot import FIRST_BOOT
from runner import diagnose, walk

OUT = os.environ.get("JOURNEY_OUT", "/tmp/journey-first-boot")


@pytest.fixture(scope="module")
def first_boot(device):
    """Walk the journey once; every check in this file reads that one walk."""
    from probes import resumed_activity
    where = resumed_activity(device)
    if "setupwizard" not in where.lower():
        pytest.skip(f"device is not at the start of the wizard (on {where}); "
                    f"restart it with -wipe-data")
    _warn_if_image_is_stale(device)
    result = walk(FIRST_BOOT, device, OUT)
    print(f"\ntraversed: {' -> '.join(result.traversed)}")
    if result.missed:
        print(f"not traversed: {', '.join(result.missed)}")
    for d in result.deviations:
        print(f"deviation: {d}")
    return result


def _warn_if_image_is_stale(device: str) -> None:
    """Fail loudly when the device is not running what was last built.

    `m <module>` rebuilds an APK into out/ and does **not** regenerate the
    partition images the emulator boots from. The module build is green, the
    emulator still runs the previous image, and a journey then reports steps as
    missing that are in fact present in the source — which is the most
    misleading failure this suite can produce, because it looks exactly like a
    real defect.
    """
    product_out = os.environ.get("ANDROID_PRODUCT_OUT", "")
    if not product_out:
        return
    from probes import _adb
    built = os.path.join(product_out, "system_ext", "priv-app",
                         "LineageSetupWizard", "LineageSetupWizard.apk")
    if not os.path.exists(built):
        return
    on_device = _adb(device, "shell", "stat", "-c", "%Y",
                     "/system_ext/priv-app/LineageSetupWizard/LineageSetupWizard.apk").strip()
    if not on_device.isdigit():
        return
    if int(os.path.getmtime(built)) > int(on_device) + 60:
        pytest.fail(
            "the device is running an older build than the tree: the setup wizard on "
            "it predates the one in out/. `m <module>` does not rebuild the partition "
            "images — run a full `m` and restart the emulator, or this journey will "
            "report perfectly good steps as missing.")


def _reached(walk_result, name: str) -> bool:
    return any(s.screen == name and s.reached for s in walk_result.steps)


@evidence("measured")
@scenario("@SETUP-11")
def test_wizard_is_eos_branded(first_boot, device):
    assert _reached(first_boot, "WelcomeActivity"), \
        f"the welcome screen was never reached\n{diagnose(device, OUT, 'welcome')}"


@evidence("measured")
@scenario("@SETUP-13")
def test_account_step_is_offered(first_boot, device):
    assert _reached(first_boot, "EAccountManagerActivity"), \
        ("the Murena Workspace account step was never reached — it is wired into "
         f"the wizard but nothing leads to it\n{diagnose(device, OUT, 'account')}")


@evidence("measured")
@scenario("@SETUP-16")
def test_parental_control_step_is_offered(first_boot, device):
    assert _reached(first_boot, "ParentalControlActivity"), \
        f"the parental control step was never reached\n{diagnose(device, OUT, 'parental')}"


@evidence("measured")
@scenario("@SETUP-12")
def test_account_step_comes_after_date_and_time(first_boot):
    order = first_boot.traversed
    if "DateTimeActivity" not in order or "EAccountManagerActivity" not in order:
        pytest.skip("one of the two steps was not traversed")
    assert order.index("DateTimeActivity") < order.index("EAccountManagerActivity"), \
        f"the account step came before date and time: {' -> '.join(order)}"


@evidence("measured")
@scenario("@SETUP-19")
def test_recovery_update_is_never_offered(first_boot):
    assert not any("Recovery" in s.screen for s in first_boot.steps if s.reached), \
        f"a recovery update step was offered: {' -> '.join(first_boot.traversed)}"
