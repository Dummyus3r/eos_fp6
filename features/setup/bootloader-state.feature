# Source: packages/apps/SetupWizard
#   SetupWizard: Turn off OEM unlocking during initial setup if bootloader is locked
#   SetupWizard: Toggle oem unlocking toggle for Pixel 5 only

@setupwizard @setup @security
Feature: OEM unlocking is turned off once the device is secured

  A device that ships with a locked bootloader but with OEM unlocking still
  enabled can be unlocked and wiped by anyone holding it. /e/OS closes that gap
  during setup.

  @SETUP-6
  Scenario: The toggle is turned off on a locked device
    Given the device bootloader is locked
    And OEM unlocking is enabled
    When the first-time setup wizard runs
    Then OEM unlocking is turned off

  @SETUP-7
  Scenario: An unlocked device is left alone
    Given the device bootloader is unlocked
    When the first-time setup wizard runs
    Then OEM unlocking is left as it is
    And the user can still re-lock and unlock the device themselves
