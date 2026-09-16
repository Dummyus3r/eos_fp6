# Source: bootable/recovery
#   recovery: ui: rebrand logo and initial /e/ layout
#   Remove ip address from recovery ui
#   recovery: Update FastbootD and recovery images
#   Revert "recovery: Ask to reboot before installing anything after A/B update"

@recovery @device @branding
Feature: Recovery

  Background:
    Given the device runs the /e/OS recovery

  Scenario: The recovery is /e/-branded
    When the recovery starts
    Then the /e/OS logo and layout are shown

  Scenario: The recovery does not display the device's IP address
    When the recovery is shown
    Then no IP address is displayed

  Scenario: Consecutive sideloads on an A/B device
    Given an update has just been applied on an A/B device
    When the user sideloads another package
    Then the recovery does not force a reboot in between
