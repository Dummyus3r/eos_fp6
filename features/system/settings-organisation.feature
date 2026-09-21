# Source: packages/apps/Settings
#   Move backup entry to top level settings
#   Settings: top_level_settings: Move accounts entry to top
#   Settings: Move updater to top of settings main page
#   Settings: Integrate Advanced Privacy into settings
#   Settings: add parental control changes / find my device entry
#   Remove smart cleanup card
#   Settings: Remove security settings placeholder
#   Allow to remove tint for homepage icons
#   Change default highlight key which makes top entries visible in tablet
#   fix security screen in setup wizard being cut in portrait mode of tablet
#   Settings: Add /e/ legal
#   Settings: res: Set proper title for system version
#   config_use_legacy_suggestion=false, contextual card feedback -> contact@e.email
# Source: vendor/lineage
#   Revert settings card layout

@settings @system
Feature: The Settings home page is organised around /e/OS

  LineageOS keeps the AOSP settings home page, where what matters on an /e/OS
  device — the account, the backup, the privacy dashboard, the updates — is
  scattered or absent. /e/OS puts those entries at the top, removes the
  Google-oriented cards and adds its own legal information.

  Background:
    Given the device runs /e/OS

  Scenario: The /e/OS entries are at the top of the settings home page
    When the user opens Settings
    Then the accounts entry is at the top level
    And the backup entry is at the top level
    And the system update entry is near the top
    And the Advanced Privacy entry is at the top level
    And the parental control entry is at the top level
    And the Find My Device entry is at the top level

  Scenario: Google-oriented suggestion cards are gone
    When the user opens Settings
    Then no smart cleanup card is shown
    And no contextual suggestion card is shown

  Scenario: Placeholders are removed
    When the user opens the security settings
    Then no empty placeholder entry is shown

  Scenario: The version entry names /e/OS
    When the user opens "About phone"
    Then the system version entry is titled with the /e/OS name

  Scenario: /e/OS legal information is available
    When the user opens the legal information
    Then the /e/OS licence and legal notices are listed

  Scenario: Feedback goes to /e/OS
    When the user sends feedback from Settings
    Then it is addressed to the /e/OS contact address

  Scenario: The homepage icons follow the /e/OS style
    Then the homepage entry icons are rendered with the /e/OS treatment

  Scenario: The settings tree is usable on a tablet
    Given the device is a tablet
    When the user opens Settings
    Then the top entries are visible without scrolling
    And the security screen is not clipped in portrait
