# Source: vendor/eos config/permissions/eos-permissions.xml
# Source: vendor/eos config/permissions/eos-allowlist.xml
# Source: frameworks/base
#   base: Grant internet permission for new/updated system apps
#   base: Grant /e/ Drive storage permission
# Source: device/lineage/sepolicy
#   lineage: Allow platform apps to read custom props
#   sepolicy: All platform app to create sockets
#   sepolicy: allow platform_app access app_data_file
#   sepolicy: allow platform_app rs_exec / named pipes

@vendor-eos @frameworks-base @sepolicy @apps
Feature: Preinstalled applications are usable without a permission gauntlet

  A user who has just flashed /e/OS should not be asked to grant twenty
  permissions before the device works. /e/OS pre-grants the preinstalled
  applications the permissions their advertised function requires — and only
  those — while leaving the user free to revoke them.

  Background:
    Given a freshly flashed /e/OS device

  Scenario Outline: Preinstalled applications hold the permissions they need
    When the user opens <application> for the first time
    Then it already holds the permissions required for <purpose>
    And the user is not shown a runtime permission prompt for them

    Examples:
      | application            | purpose                                   |
      | the calendar           | reading and writing calendars             |
      | the mail application   | reading contacts for address completion   |
      | the maps application   | location, and navigation audio            |
      | the camera             | camera and microphone                     |
      | /e/ Drive              | reading and writing the user's files      |
      | the account manager    | contacts, calendars and tasks             |
      | the SMS synchroniser   | reading SMS and contacts                  |
      | the screen reader      | accessibility, audio and bluetooth        |
      | Find My Device         | location and SMS                          |
      | Parental Control       | usage statistics, alarms and overlay      |

  Rule: Pre-granted permissions stay under the user's control

    Scenario: The user revokes a pre-granted permission
      Given a preinstalled application holds a pre-granted permission
      When the user revokes it
      Then the revocation is honoured
      And it is not silently granted again

    Scenario: One permission is fixed because the application cannot work without it
      Then /e/ Drive's management of all files is granted as a fixed permission

  Scenario: Background-critical applications survive Doze
    Given the device is idle
    Then the account manager, the privacy dashboard, the store, the calendar, the notification relay and the updater are allowed to run in power save

  Scenario: System applications keep network access after an update
    Given a system application is updated
    When it restarts
    Then it still has network access
    And the user does not have to re-authorise it

  Scenario: Platform applications can use the system integration points they need
    Then SELinux allows platform applications to read /e/OS custom properties
    And to create the sockets and pipes the /e/OS services rely on
