# Source: frameworks/base
#   keystore: Block key attestation for SafetyNet (SafetyNetHooks)
#   Spoof MODEL, DEVICE, PRODUCT & FINGERPRINT
#   SNHooks: Set Build.TYPE to userdebug for dockmanager
# Source: external/ih8sn, vendor/eos config/ih8sn/*
# Source: system/core
#   Spoof yellow verified boot state to green
# Source: build/soong
#   Spoof build variant by removing "debug" in Settings > About Phone
#   Change build description in Settings > About Phone

@frameworks-base @system-core @ih8sn @compatibility
Feature: Applications that check device integrity keep working

  Banking, transport and streaming applications refuse to run when they detect a
  custom ROM or an unlocked bootloader — which is the normal state of a
  LineageOS device. /e/OS presents the device as a stock, locked device to those
  checks, so those applications run without the user having to patch anything.

  Background:
    Given the device runs /e/OS
    And the build ships the integrity compatibility daemon

  Scenario: Basic integrity checks pass
    When an application runs a device-integrity check
    Then the reported build fingerprint, model, device and product are those of a stock build
    And the build type and tags are those of a release build

  Scenario: Hardware-backed attestation is not used against the device
    When the integrity check opportunistically requests a hardware key attestation
    Then the platform reports that key attestation is unavailable
    And the check falls back to its basic path

  Scenario: Legitimate uses of key attestation still work
    Given an application other than the integrity checker requests a key attestation
    When the request is made
    Then it is served normally

  Scenario: Verified boot reports a green state
    When an application reads the verified boot state
    Then it reads "green" rather than "yellow"

  Scenario: The build does not advertise itself as a debug build
    When the user opens "About phone"
    Then the build number does not contain "debug"
    And the build description matches the /e/OS release

  Rule: The compatibility daemon is not shipped where it is counter-productive

    Some anti-tampering SDKs bundled in third-party applications detect the
    daemon itself, which makes shipping it worse than not shipping it. The
    build variant decides, and it decides first: a "user" build never gets the
    daemon, whatever the release type.

    Scenario: A user build
      Given the build variant is "user"
      Then the integrity compatibility daemon is not included in the image
      And this holds even for an official, community or partner release

    Scenario: A community, official or partner build that is not a user build
      Given the build variant is not "user"
      And the release type is official, community or partner
      Then the integrity compatibility daemon is included in the image

    Scenario: Any other build
      Given the build variant is not "user"
      And the release type is not official, community or partner
      Then the integrity compatibility daemon is not included in the image

    Scenario: The daemon is configured per device
      Given the integrity compatibility daemon is included
      Then a device-specific configuration is installed when one exists
      And the default configuration is installed otherwise

  Rule: The build-property spoofing is separate from the daemon

    The spoofed build fingerprint, the blocked key attestation and the green
    verified boot state are platform changes; they are present whatever the
    build variant. Only the daemon is gated.

    Scenario: A user build still reports a stock build
      Given the build variant is "user"
      Then the reported build fingerprint, model, device and product are still those of a stock build
      And key attestation is still withheld from the integrity checker
