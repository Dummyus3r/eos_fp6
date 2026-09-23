# Source: packages/apps/Settings
#   Settings: add find my device entry in settings
#     (FindMyDeviceDashboardFragment, TopLevelFindMyDeviceEntryPreferenceController)
#   Settings: Remove find my device from security settings summary
# Source: packages/apps/SetupWizard
#   Adding the Find my device screen to FTW
# Source: vendor/eos config/permissions (foundation.e.findmydevice)

@settings @setupwizard @system @prebuilt-boundary
Feature: Find My Device

  LineageOS has no device-finding feature; the AOSP one is Google's. /e/OS ships
  its own, which locates and acts on the device over SMS rather than through a
  cloud service, and surfaces it where a user would look for it.

  The application itself is specified in its own repository.

  Background:
    Given the device runs /e/OS
    And the /e/OS Find My Device application is preinstalled

  @SYS-4
  Scenario: Find My Device is reachable from Settings
    When the user opens Settings
    Then a Find My Device entry is shown at the top level
    And it opens the /e/OS Find My Device application

  @SYS-5
  Scenario: The Google entry is gone
    When the user opens the security settings
    Then no Google Find My Device entry is offered

  @SYS-6
  Scenario: Find My Device can be enabled during setup
    When the user goes through the first-time setup wizard
    Then a Find My Device step is offered

  @SYS-7
  Scenario: The application holds the permissions it needs
    Then Find My Device already holds the location, SMS and notification permissions
    And it can therefore answer a locate request without the user unlocking the device first

  @SYS-8
  Scenario: The entry is localised
    Then the Find My Device entry is translated in the languages /e/OS ships
