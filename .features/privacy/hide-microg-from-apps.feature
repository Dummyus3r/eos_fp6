# Source: frameworks/base
#   feat: Introduce Hide From Microg feature
#   Settings.System.HIDE_MICROG_PACKAGES_FOR_PACKAGE
#   AppsFilterBase / AppsFilterImpl / PackageManagerService
# Other half: microG itself owns the user-facing list and writes the setting.
#   https://gitlab.e.foundation/e/os/GmsCore
#   The UI for choosing which applications microG hides from is specified there;
#   this file specifies the platform contract microG writes against.

@frameworks-base @privacy @compatibility
Feature: Hiding microG from selected applications

  /e/OS ships microG in place of Google Play services. Some applications behave
  worse when they detect a Play-services-like package — they push a Google
  sign-in, refuse to fall back to their non-Google code path, or flag the device.
  /e/OS lets microG be hidden from a chosen application, so that application sees
  a device with no Play services at all, while every other application keeps
  using microG normally.

  This is not possible on LineageOS, where package visibility cannot be filtered
  per application from a setting.

  Background:
    Given the device runs /e/OS
    And microG is installed
    And microG maintains the list of applications it should be hidden from

  Scenario: An application on the hide list cannot see microG
    Given microG has been asked to hide itself from "com.example.banking"
    When "com.example.banking" queries the installed packages
    Then microG's packages are absent from the result
    And "com.example.banking" cannot resolve microG's services

  Scenario: Other applications still use microG
    Given microG has been asked to hide itself from "com.example.banking"
    When "com.example.messaging" queries the installed packages
    Then microG's packages are present in the result
    And push notifications delivered through microG keep working for "com.example.messaging"

  Scenario: The hide list holds several applications
    Given the hide list contains "com.example.banking" and "com.example.gov"
    Then microG is hidden from both applications
    And it stays visible to every other application

  Scenario: Changing the list takes effect without a reboot
    Given microG is visible to "com.example.banking"
    When microG adds "com.example.banking" to the hide list
    Then microG becomes invisible to "com.example.banking"
    And no reboot is required

  Scenario: The list is per user
    Given the device has a primary user and a secondary user
    And microG is hidden from "com.example.banking" for the primary user only
    When "com.example.banking" runs as the secondary user
    Then it can see microG

  Scenario: Only microG maintains the list
    Then the setting holding the list is a private system setting
    And a third-party application cannot read or write it

  Scenario: An empty list hides nothing
    Given the hide list is empty
    Then microG is visible to every application
