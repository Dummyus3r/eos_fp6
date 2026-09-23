# Source: frameworks/base
#   base: allow parental control to be activated with accounts (DevicePolicyManagerService)
# Source: packages/apps/Settings
#   Settings: add parental control changes (ParentalControlDashboardFragment,
#     top_level_settings, admin-disabled wording)
# Source: packages/apps/LineageParts
#   Parts: Disable advance reboot for parental control
# Source: packages/apps/SetupWizard
#   Add parental control page
# Source: vendor/eos config/permissions (foundation.e.parentalcontrol)

@frameworks-base @settings @lineageparts @system @prebuilt-boundary
Feature: Parental control

  /e/OS ships a parental control application that becomes the device owner in
  order to enforce its restrictions. AOSP — and therefore LineageOS — refuses to
  set a device owner once user accounts exist, which would mean parental control
  could only ever be set up on a factory-fresh device before any account is
  added. /e/OS lifts that restriction for the parental control application only,
  and removes the escape hatches a child could use.

  The rules themselves belong to the Parental Control application (own
  repository); what is specified here is the system side.

  Background:
    Given the device runs /e/OS

  @SYS-33
  Scenario: Parental control can be enabled on a device already in use
    Given accounts are registered on the device
    When the parental control application is set as device owner
    Then it is accepted

  @SYS-34
  Scenario: Other applications still cannot become device owner
    Given accounts are registered on the device
    When another application tries to become device owner
    Then it is refused because accounts are present

  @SYS-35
  Scenario: Parental control is reachable from the top of Settings
    When the user opens Settings
    Then a parental control entry is shown at the top level

  @SYS-36
  Scenario: A restriction is explained as coming from parental control
    Given parental control restricts a setting
    When the user opens that setting
    Then they are told the restriction comes from parental control
    And the wording does not refer to a company IT administrator

  @SYS-37
  Scenario: Advanced reboot cannot be used to bypass parental control
    Given parental control is active
    When the user opens the power menu
    Then the advanced reboot options are not offered

  @SYS-38
  Scenario: Parental control can be set up from the first-time wizard
    When the user goes through the first-time setup wizard
    Then a parental control step is offered

  @SYS-39
  Scenario: The application holds the permissions it needs
    Then the parental control application already holds the usage statistics, exact alarm, overlay and boot-completed permissions
