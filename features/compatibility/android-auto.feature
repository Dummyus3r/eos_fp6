# Source: frameworks/base
#   Allow to install Google signed Android Auto APK
#     InstallPackageHelper#isAndroidAutoApk, PackageManagerServiceUtils#isAndroidAutoApk
#   Android Auto: Support Android Auto as user app 1/2
#     PermissionManagerServiceImpl: PACKAGE_ANDROID_AUTO,
#     SIGNATURE_ANDROID_AUTO (pinned SHA-256 of Google's signing certificate),
#     PERMISSIONS_ANDROID_AUTO (13 privileged permissions)
# Source: packages/modules/Permission
#   Android Auto: Support Android Auto as user app 2/2
# Source: frameworks/base core/res config.xml
#   config_systemAutomotiveProjection -> gearhead + the same certificate digest
#   config_companionDevicePackages / config_companionDeviceCerts -> gearhead
# Source: external/prebuiltapks AndroidAutoStub
#
# ---------------------------------------------------------------------------
# Why it is done this way, and what else was possible
# ---------------------------------------------------------------------------
# Android Auto (com.google.android.projection.gearhead) is only functional when
# it is a *privileged system* application: it needs INTERNAL_SYSTEM_WINDOW,
# MANAGE_USB, MODIFY_AUDIO_ROUTING, READ_PRIVILEGED_PHONE_STATE,
# BLUETOOTH_PRIVILEGED, CONTROL_INCALL_EXPERIENCE and others that Android only
# grants to applications present in the system image and allowlisted there.
# /e/OS cannot ship the real APK — it is proprietary and not redistributable.
#
# The options were:
#
# (a) Do not support Android Auto at all. This is what LineageOS does. The user
#     can side-load the APK; it installs and then fails, because the privileged
#     permissions it needs are not grantable to a user-installed application.
#     Cost: a feature a large share of drivers consider non-negotiable.
#
# (b) Ship the real APK. Not possible: redistribution is not licensed.
#
# (c) Ship an empty stub in the system image that declares the package name and
#     the privileged permission allowlist, and let the user install the real,
#     Google-signed APK over it. This is what /e/OS does. It requires relaxing
#     the "an update must be signed by the same key as what it replaces" rule
#     for exactly this case.
#
# (d) Same as (c), but relax the signature check for any package overwriting a
#     stub. Rejected: that is a general privilege-escalation primitive.
#
# The relaxation implemented is (c), narrowed twice: the package name must be
# exactly com.google.android.projection.gearhead, *and* the installed APK's
# signing chain must contain a certificate whose SHA-256 digest is the one
# pinned in the platform. An attacker who controls neither cannot use it. The
# privileged permissions are granted only to a package satisfying both
# conditions, and only the 13 permissions on the pinned list.
#
# What is still given up compared to a device with no Android Auto: the user is
# installing a proprietary, Google-signed, privileged application. That is the
# user's decision to make, and it is the point of the feature — but it is a
# genuine trade-off, not a free one.
# ---------------------------------------------------------------------------

@frameworks-base @permission @compatibility @prebuilt-boundary
Feature: Android Auto can be installed by the user

  Android Auto expects to be a privileged system application signed by Google.
  On LineageOS it simply cannot be installed in a working state. /e/OS ships an
  empty stub that reserves the package name and the privileges, and lets the
  user install the real, Google-signed APK on top of it.

  Background:
    Given the device runs /e/OS
    And the Android Auto stub is preinstalled in the system image

  @COMPAT-1
  Scenario: The user installs the real Android Auto
    Given the APK is named "com.google.android.projection.gearhead"
    And its signing chain contains the certificate digest pinned in the platform
    When the user installs it
    Then the installation is accepted although the stub carries a different signature
    And the installed application replaces the stub

  @COMPAT-2
  Scenario: The installed application gets the privileges the stub reserved
    Given the real Android Auto has been installed over the stub
    When it checks one of the privileged permissions on the pinned list
    Then the permission is reported as granted

  @COMPAT-3
  Scenario: Only the pinned permissions are granted
    Given the real Android Auto has been installed over the stub
    When it checks a privileged permission that is not on the pinned list
    Then the permission is not granted by virtue of being Android Auto

  @COMPAT-4
  Scenario: Android Auto is usable
    Given the real Android Auto has been installed
    When the user connects the device to a compatible head unit
    Then Android Auto starts

  @COMPAT-5
  Scenario: It holds the automotive projection role
    Then the platform recognises it as the system automotive projection application
    And that recognition is pinned to the same certificate digest as the installation

  @COMPAT-6
  Scenario: It can manage its own companion device association
    When it associates with a head unit
    Then it is treated as an allowed companion device application
    And that allowance is pinned to the same certificate

  Rule: The relaxation is pinned to one package and one signing certificate

    @COMPAT-7
    Scenario: A package with the right name but the wrong signature
      Given an APK named "com.google.android.projection.gearhead"
      And its signing chain does not contain the pinned certificate digest
      When the user installs it
      Then the installation is refused because the signatures do not match

    @COMPAT-8
    Scenario: A different package signed by the same certificate
      Given an APK signed by the pinned certificate but with another package name
      When it tries to overwrite a system application
      Then the installation is refused because the signatures do not match
      And it is not granted the Android Auto privileged permissions

    @COMPAT-9
    Scenario: Any other package overwriting a system application
      When a third-party package tries to overwrite a system application
      Then the installation is refused because the signatures do not match
