# Source: packages/apps/SetupWizard
#   Add restore page for backup app
#   Launch restore when EAccount is available
#   feat:4037: set e account setting early, before restore eBackup step
#   Skip theme, FMD and navigation settings if restore finished
#   Update restore activity action
#   fix restore intro restore button binding
#   Move account check to helper class
# Source: external/prebuiltapks Backup

@setupwizard @setup @prebuilt-boundary
Feature: Restoring a backup during first-time setup

  LineageOS has no restore step. /e/OS lets a user who signs into their /e/OS
  account pull a previous device's backup during setup, so a replacement phone
  comes back with its applications and settings without any Google backup
  involved.

  The backup itself belongs to the Backup application (own repository); what is
  specified here is the wizard's part.

  Background:
    Given a device running /e/OS that has never been set up

  Scenario: The restore step is offered once an account is available
    Given the user has signed into their Murena Workspace account during setup
    When the wizard continues
    Then a restore step is offered
    And the user can choose to restore a backup or to continue without one

  Scenario: The account is usable before the restore runs
    Given the user has just signed into their Murena Workspace account
    When the restore step starts
    Then the account is already registered on the device
    And the restore can read the user's backups

  Scenario: The restore step is skipped without an account
    Given the user skipped the Murena Workspace account step
    When the wizard continues
    Then no restore step is offered

  Scenario: A completed restore short-circuits the remaining preference steps
    Given the user has restored a backup
    When the wizard continues
    Then the theme step is skipped
    And the Find My Device step is skipped
    And the navigation settings step is skipped
    And the restored values are kept

  Scenario: Declining the restore keeps the normal flow
    Given the user chose not to restore
    Then the theme, Find My Device and navigation steps are shown as usual
