# Source: packages/apps/Settings
#   Write telemetry system settings (EnableTelemetryPreferenceController)
#   Settings: add preference for sentry user id (SentryDetailPreferenceController)
#   Add a dedicated section in developer options for /e/OS related settings
# Source: packages/apps/LineageParts
#   LineageParts: Remove LineageOS stats collection support completely
#   LineageParts: Set sentry user id on boot
# Source: packages/apps/SetupWizard
#   SetupWizard: Disable LineageOS metrics

@settings @lineageparts @setupwizard @privacy
Feature: No statistics collection, opt-in crash reporting only

  LineageOS asks during setup whether to send anonymous usage statistics to the
  LineageOS servers, and keeps a statistics uploader in LineageParts. /e/OS
  removes that mechanism outright — there is nothing to opt out of — and offers
  in its place a crash-reporting switch that is off unless the user turns it on.

  Background:
    Given the device runs /e/OS

  @PRIV-26
  Scenario: Setup never proposes statistics collection
    When the user goes through the first-time setup wizard
    Then no screen offers to send usage statistics
    And no statistics are ever uploaded to LineageOS infrastructure

  @PRIV-27
  Scenario: The statistics feature is absent from the settings tree
    When the user browses the /e/OS settings
    Then there is no "LineageOS statistics" entry
    And there is no statistics uploader on the device

  @PRIV-28
  Scenario: Crash reporting is off by default
    Given the device has just been set up
    When the user opens developer options
    Then the telemetry switch is off
    And no crash report is sent

  @PRIV-29
  Scenario: The user turns crash reporting on
    Given the user has enabled developer options
    When the user turns the telemetry switch on
    Then the choice is stored as a system setting
    And crash reports may be sent from that point on

  @PRIV-30
  Scenario: The user can see and share the identifier attached to reports
    Given telemetry is enabled
    When the user opens the telemetry section of developer options
    Then the anonymous reporting identifier is displayed
    And the user can copy it in order to reference their own reports

  @PRIV-31
  Scenario: The identifier is stable across reboots
    Given telemetry is enabled and an identifier has been generated
    When the device reboots
    Then the same identifier is used

  @PRIV-32
  Scenario: /e/OS-specific developer settings are grouped
    When the user opens developer options
    Then the /e/OS-specific entries are gathered in their own section
    And they are not interleaved with the AOSP entries
