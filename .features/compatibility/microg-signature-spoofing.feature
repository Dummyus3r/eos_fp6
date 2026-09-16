# Source: frameworks/base
#   Allow signature spoofing for system apps (ComputerEngine)
# Source: vendor/eos config/permissions/eos-permissions.xml
#   com.google.android.gms: FAKE_PACKAGE_SIGNATURE, INSTALL_LOCATION_PROVIDER,
#                           CHANGE_DEVICE_IDLE_TEMP_WHITELIST
#   com.android.vending: FAKE_PACKAGE_SIGNATURE
# Source: packages/apps/LineageParts
#   LineageParts: Add microg to system settings
#   feat: rename "microG" into "App compatibility"

@frameworks-base @lineageparts @compatibility
Feature: microG support out of the box

  microG needs to present itself to applications as Google Play services, which
  requires the platform to report a signature it does not actually have.
  LineageOS refuses this by design, so microG has to be side-loaded onto a
  patched build. /e/OS ships microG preinstalled and grants it exactly the
  privileges it needs, so Google-dependent applications work on a device that
  has no Google code on it.

  Background:
    Given the device runs /e/OS
    And microG and the FakeStore are preinstalled as system applications

  Scenario: microG reports itself as Play services
    When an application queries the signature of the Play services package
    Then it is given the signature microG declares
    And the application uses its Google code path

  Rule: Signature spoofing is restricted to system applications

    Scenario: A third-party application cannot spoof a signature
      Given a third-party application declares the fake-signature permission
      When it is installed
      Then the permission is not granted
      And it reports its own signature

    Scenario: Only explicitly allowed system packages spoof
      When the list of packages granted the fake-signature permission is inspected
      Then it contains only microG and the FakeStore

  Scenario: microG can act as a location provider
    When microG registers a network location provider
    Then the platform accepts it

  Scenario: microG keeps working under Doze
    Given the device is idle
    When microG needs to deliver a push message
    Then it is allowed to leave the idle allowlist temporarily
    And it is exempted from power-save restrictions

  Scenario: The user can configure microG from the settings
    When the user opens the /e/OS settings
    Then an "App compatibility" entry leads to the microG settings
    And the entry is not labelled "microG"
