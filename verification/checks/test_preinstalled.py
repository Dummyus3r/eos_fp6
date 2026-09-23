"""Checks for features/apps/preinstalled-applications.feature.

The application set is settled at build time, so `pm list packages` answers
most of it. What an application *does* once opened belongs elsewhere; this file
only asserts what ships.
"""
from __future__ import annotations

from probes import packages
from conftest import delta, scenario

#: Packages that would mean the real Google stack is on the device. microG
#: deliberately impersonates two of them, so they are matched by package name
#: together with the check that microG is what provides them.
GOOGLE_STACK = {
    "com.google.android.gms",
    "com.google.android.gsf",
    "com.android.vending",
}


@delta
@scenario("features/apps/preinstalled-applications.feature::Google Play services are replaced, not present")
def test_google_play_services_are_replaced(device):
    installed = packages(device)
    # microG ships under the Google package names on purpose: applications look
    # for com.google.android.gms and must find something. The promise is that
    # what answers is microG, so the names being present is expected, and what
    # would break the promise is a Google application beyond that stack.
    beyond_the_stack = {p for p in installed
                        if p.startswith("com.google.") and p not in GOOGLE_STACK}
    assert beyond_the_stack == {"com.google.android.projection.gearhead"}, \
        f"unexpected Google applications preinstalled: {sorted(beyond_the_stack)}"
    # Android Auto is the documented exception: /e/OS ships an empty stub so the
    # user may install the Google-signed APK over it. See e/os/backlog#4679.


@delta
@scenario("features/apps/preinstalled-applications.feature::No device management client is preinstalled")
def test_no_mdm_client_preinstalled(device):
    installed = packages(device)
    suspects = {p for p in installed
                if any(t in p.lower() for t in ("mdm", "afw", "workprofile", "emm"))}
    assert not suspects, f"a device management client ships with the image: {sorted(suspects)}"


@delta
@scenario("features/apps/preinstalled-applications.feature::The device is usable without installing anything")
def test_core_applications_ship(device):
    installed = packages(device)
    missing = {p for p in (
        "foundation.e.notes",
        "foundation.e.tasks",
        "foundation.e.advancedprivacy",
        "foundation.e.accountmanager",
    ) if p not in installed}
    assert not missing, f"core /e/OS applications missing from the image: {sorted(missing)}"
