# Source: bootable/recovery
#   recovery: ui: rebrand logo and initial /e/ layout
#   Remove ip address from recovery ui
#   recovery: Update FastbootD and recovery images
#   Revert "recovery: Ask to reboot before installing anything after A/B update"
# Source: bootable/deprecated-ota
#   applypatch: Always update recovery image
#   (the property gate persist.vendor.recovery_update is removed)
# Source: packages/apps/SetupWizard
#   SetupWizard: Skip recovery update option

@recovery @device @branding
Feature: Recovery

  Background:
    Given the device runs the /e/OS recovery

  Scenario: The recovery is /e/OS-branded
    When the recovery starts
    Then the /e/OS logo and layout are shown

  Scenario: The recovery does not display the device's IP address
    When the recovery is shown
    Then no IP address is displayed

  Scenario: Consecutive sideloads on an A/B device
    Given an update has just been applied on an A/B device
    When the user sideloads another package
    Then the recovery does not force a reboot in between

  Rule: The recovery is never left behind by the system

    On a device using the legacy OTA path, AOSP only reflashes the recovery
    when a property asks for it, and LineageOS leaves the user to decide during
    setup. A device whose recovery is older than its system cannot be recovered
    reliably, so /e/OS removes the choice and keeps them in step.

    Scenario: The recovery is refreshed on boot
      Given the device uses the legacy recovery update path
      When the device boots after a system update
      Then the recovery image is updated
      And it does not depend on a property being set

    Scenario: The user is not asked
      When the user goes through the first-time setup wizard
      Then no recovery update option is offered
