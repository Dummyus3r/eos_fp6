# Source: packages/apps/Settings
#   Settings: Integrate Advanced Privacy into settings
#     (AdvancedPrivacyDashboardFragment, advanced_privacy_dashboard_settings.xml)
# See also privacy/tracker-blocking-dns.feature and privacy/fake-location.feature

@settings @privacy @prebuilt-boundary
Feature: Advanced Privacy is part of the settings

  Advanced Privacy is where the user controls tracker blocking, IP address
  hiding and fake location. It is an application, but on /e/OS it is presented
  as a settings section so that a user looking for privacy controls finds it
  where they expect it. LineageOS has no equivalent.

  Background:
    Given the device runs /e/OS
    And Advanced Privacy is preinstalled

  Scenario: Advanced Privacy appears in Settings
    When the user opens Settings
    Then an Advanced Privacy entry is shown at the top level with its own icon

  Scenario: The entry opens the privacy dashboard
    When the user taps the Advanced Privacy entry
    Then the Advanced Privacy dashboard is opened

  Scenario: The entry is searchable
    When the user searches the settings for privacy
    Then the Advanced Privacy entry is among the results
