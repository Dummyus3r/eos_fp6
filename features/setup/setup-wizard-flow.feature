# Source: packages/apps/SetupWizard
#   Replace lineage strings and logo with /e/
#   SetupWizard: Add /e/ account manager page
#   Move account setup after date & time
#   Hide login/create if logged in
#   Theme app according to our palette
#   Add parental control page
#   Adding the Find my device screen to FTW
#   SetupWizard: Enable wifi location
#   SetupWizard: Skip recovery update option
#   Set BlissLauncher as default when moments is installed
#   Fix welcome layout root id in sw600dp and tv
#   Port translations from A14

@setupwizard @setup
Feature: First-time setup wizard

  The LineageOS wizard sets up an ordinary AOSP device. The /e/OS wizard sets up
  an /e/OS device: it carries /e/OS branding, it offers the Murena Workspace account that the
  rest of the system is built around, and it walks the user through the features
  that make the device private by default.

  Background:
    Given a device running /e/OS that has never been set up
    When the user starts the first-time setup wizard

  @SETUP-11
  Scenario: The wizard is /e/OS-branded
    Then the welcome screen shows the /e/OS name and logo
    And no screen mentions LineageOS
    And every screen follows the /e/OS colour palette

  @SETUP-12
  Scenario: Order of the steps
    Then the date and time step comes before the account step
    And the Murena Workspace account step comes after it

  @SETUP-13
  Scenario: The user creates or signs into a Murena Workspace account
    When the user reaches the account step
    Then the user can sign into an existing Murena Workspace account
    And the user can create a new one
    And the user can skip the step

  @SETUP-14
  Scenario: An account that is already present is not asked for again
    Given a Murena Workspace account is already registered on the device
    When the user reaches the account step
    Then the sign-in and create options are hidden

  @SETUP-15
  Scenario: Location for Wi-Fi scanning is proposed
    When the user reaches the location step
    Then Wi-Fi-based location can be enabled from the wizard

  @SETUP-16
  Scenario: Parental control can be set up during setup
    When the user reaches the parental control step
    Then the user can turn parental control on for this device
    And the user can skip the step

  @SETUP-17
  Scenario: Find My Device can be set up during setup
    When the user reaches the Find My Device step
    Then the user can enable Find My Device
    And the user can skip the step

  @SETUP-18
  Scenario: The launcher is set during setup
    Given BlissLauncher is installed
    When setup completes
    Then BlissLauncher is the default home application

  @SETUP-19
  Scenario: The recovery update prompt is not shown
    Then the wizard never offers to update the recovery image
    # Because /e/OS updates it unconditionally: device/recovery.feature

  @SETUP-20
  Scenario: The wizard is usable on a tablet
    Given the device is a tablet
    Then the welcome screen lays out correctly in portrait and landscape

  @SETUP-21
  Scenario: The wizard is translated
    Then every /e/OS-specific screen is available in the languages /e/OS ships
