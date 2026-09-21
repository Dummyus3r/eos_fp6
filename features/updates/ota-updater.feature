# Source: packages/apps/Updater
#   Updater: Rebrand to /e/ OS
#   Updater: Update the OTA url / Change default user-agent / Get /e/ release notes
#   Updater: Allow OTA updates with different version number
#   Updater: Check updates daily
#   Updater: Enable auto deletion of updates by default
#   Updater: Update A/B devices on one go
#   Updater: Check for free space on install
#   Updater: Add network ConnectionStateMonitor
#   Updater: Add permanent reboot notification & delete update
#   Updater: add option to show all updates
#   Updater: /e/ changes for local update
#   Updater: Generate anon id for ota requests
#   Updater: Improve UX for users taking version upgrades
#   Updater: Add support for SystemUpdateManager status
#   Use custom tab intent for changelog
#   Update: add json validator
# Source: packages/apps/Settings
#   Settings: Move updater to top of settings main page
#   Settings: Switch to select prod or staging OTA server
#   Settings: Change updater summary for /e/OS version
# Source: device/lineage/sepolicy
#   sepolicy: Updater: Add support for systemUpdatermanager

@updater @settings @updates
Feature: /e/OS system updates

  The updater is forked from LineageOS but points at /e/OS infrastructure, checks
  on its own schedule, and is reworked so that a non-technical user is guided
  through an update rather than left with a list of build files.

  Background:
    Given the device runs /e/OS

  Scenario: Updates come from /e/OS infrastructure
    When the updater checks for updates
    Then it queries "https://ota.ecloud.global"
    And it identifies itself with the /e/OS user agent
    And the request carries an anonymous identifier rather than a device identifier

  Scenario: The device is offered updates of its own release type only
    When the updater checks for updates
    Then the request carries the device's release type
    And an update of a different release type is not offered
    # The release types and what else depends on them:
    # updates/release-types.feature

  Scenario: The system updates are reachable immediately
    When the user opens Settings
    Then the system update entry is near the top of the main page
    And its summary shows the /e/OS version

  Scenario: The device checks daily
    Given automatic checking is enabled
    Then the device checks for updates once a day

  Scenario: Release notes are shown
    When an update is available
    Then the user can read the /e/OS release notes for it
    And the notes open in an in-app browser tab

  Scenario: Android version upgrades are offered
    Given the available update targets a newer Android version than the installed one
    When the updater lists updates
    Then the update is offered
    And the user is told that this is a major upgrade

  Scenario: Older Android versions are not offered
    Given an update targets an older Android version than the installed one
    Then it is not listed

  Scenario: Free space is checked before installing
    Given there is not enough free space for the update
    When the user starts the installation
    Then the installation is refused with an explanation

  Scenario: Battery level is checked before installing
    Given the battery is below the required level and the device is not charging
    When the user starts the installation
    Then the installation is refused with an explanation

  Scenario: Downloads react to connectivity changes
    Given a download is in progress
    When the network is lost and comes back
    Then the download resumes without the user intervening

  Scenario: An A/B device installs in one pass
    Given the device uses A/B partitions
    When the user installs an update
    Then the update is downloaded and applied in a single operation

  Scenario: The user is reminded to reboot
    Given an update has been installed and a reboot is pending
    Then a notification stays in the shade until the device reboots
    And the user can delete the downloaded update from that notification

  Scenario: Downloaded updates are cleaned up
    Given an update has been applied
    Then the downloaded file is deleted automatically

  Scenario: Only the relevant update is shown by default
    When the user opens the updater
    Then only the update they should install is listed
    And the user can choose to show all available updates

  Scenario: A file can be installed from local storage
    When the user picks an update file from the device
    Then it is validated before being installed

  Scenario: Managed devices see the update state
    Given a device owner application queries the system update status
    Then it receives the state reported by the /e/OS updater

  Scenario: Testers can target the staging server
    Given the user has enabled developer mode
    And the user has enabled the staging OTA server in Settings
    When the updater checks for updates
    Then it queries "https://test.ota.ecloud.global" instead of the production server
    And this is independent of the release type of the build

  Scenario: Developer mode relaxes the strictness of the query
    Given the user has enabled developer mode
    When the updater checks for updates
    Then the query is not restricted to the single update the device should take
    And all updates the server offers for that device and release type are listed
