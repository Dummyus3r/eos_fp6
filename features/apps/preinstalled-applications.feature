# Source: external/prebuiltapks config/common.mk, config/telephony.mk
# Source: vendor/eos config/common.mk, config/common_mobile.mk
# Source: vendor/lineage
#   camera: use /e/OS camera activity
#   vendor: Exclude AudioFX by default
#   overlay: Adjust package name for our calendar
#   overlay: Dont show splash for AccountManager and PWA player
# NOTE: the behaviour of each application is specified in its own repository.
#       This file only specifies which applications the system ships and how it
#       wires them together.

@vendor-eos @prebuiltapks @apps @prebuilt-boundary @optional
Feature: The /e/OS application set

  LineageOS ships a minimal set of AOSP-derived applications and leaves the user
  to install a store. /e/OS ships a complete, Google-free application set so the
  device is usable — mail, calendar, contacts, files, maps, browser, store —
  from the first boot.
  Part of this is build-configurable: a minimal build drops the optional
  applications, and the messaging set ships only on devices with telephony.


  Background:
    Given a freshly flashed /e/OS device

  @APP-47
  Scenario: The device is usable without installing anything
    Then an application store is preinstalled
    And a mail, calendar, contacts, tasks and notes application is preinstalled
    And a file synchronisation application is preinstalled
    And a browser, a camera, a gallery, a maps application and a password manager are preinstalled
    And a privacy dashboard application is preinstalled

  @APP-48
  Scenario: Google Play services are replaced, not present
    Then microG and a store stub are preinstalled in place of Google Play services
    And no Google application is present

  @APP-49
  Scenario: Telephony devices get the messaging set
    Given the device has telephony
    Then a messaging application and an SMS synchronisation application are preinstalled

  @APP-50
  Scenario: A minimal build drops the optional applications
    Given the build is configured as minimal
    Then the optional applications are not included
    And the core /e/OS applications are still included

  @APP-51
  Scenario: Accessibility is available out of the box
    Then a screen reader is preinstalled and offered as the default accessibility service
    And a text-to-speech engine is preinstalled
    And an offline speech-to-text engine is preinstalled

  @APP-52
  Scenario: The /e/OS applications are the defaults
    Then the /e/OS camera application handles camera intents
    And the /e/OS calendar handles calendar intents
    And BlissLauncher is the default home application
    # The full set of role assignments: apps/default-app-associations.feature

  @APP-53
  Scenario: No device management client is preinstalled
    Then no MDM client ships with the device
    # Enrolment installs the operator's own: setup/enterprise-provisioning.feature

  @APP-54
  Scenario: LineageOS applications that /e/OS replaces are not shipped
    Then the LineageOS audio effects application is not included
