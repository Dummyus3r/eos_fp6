# Source: packages/apps/Settings
#   Settings: mark eDrive as safe to be opened by accountManager
#   697-s-Recalculate_accountType_sorting
#   Settings: top_level_settings: Move accounts entry to top
#   Improve wordings for automatic sync
#   Update remove account dialog message to make it more clear
#   Settings: Notify users all their accounts will be removed and not just google
# Source: packages/apps/Contacts
#   709-s-Open_accountManager_onClick_add_account
#   Contacts: Sort /e/ account with first priority and allow user to modify
#     primary account for profile
#   Issue 1776: Default to phone-only if no account
#   Issue 1756: Account selector ui fix
#   Issue 1317: Fix address books appearing repeatedly
# Source: frameworks/base
#   base: Grant /e/ Drive storage permission
# Source: vendor/eos config/permissions (foundation.e.accountmanager, foundation.e.drive)

@settings @contacts @frameworks-base @identity @prebuilt-boundary
Feature: The /e/ account is the device's primary account

  On LineageOS the account list is an unopinionated AOSP list where a Google
  account usually ends up first. On /e/OS the /e/ account is what synchronises
  contacts, calendar, tasks, mail and files, so the system treats it as the
  primary one and routes account creation to the /e/ account manager.

  Background:
    Given the device runs /e/OS
    And the /e/ account manager and /e/ Drive are preinstalled

  Scenario: Accounts are reachable from the top of Settings
    When the user opens Settings
    Then the accounts entry is at the top level and not buried in a submenu

  Scenario: The /e/ account is listed first
    Given several accounts are registered, including an /e/ account
    When the user opens the account list
    Then the /e/ account comes first

  Scenario: Adding an account goes through the /e/ account manager
    When the user chooses to add an account from Contacts
    Then the /e/ account manager is opened

  Scenario: /e/ Drive can sync files without asking for storage access
    When /e/ Drive synchronises the user's files
    Then it already holds the storage permission it needs
    And the user is not prompted

  Scenario: Contacts default to the /e/ account
    Given an /e/ account is registered
    When the user creates a contact
    Then the /e/ account is preselected

  Scenario: Contacts without any account stay on the device
    Given no account is registered
    When the user creates a contact
    Then it is saved as a phone-only contact
    And no account selector is shown

  Scenario: Each address book appears once
    Given an /e/ account with several address books
    When the user opens the contact list filter
    Then every address book is listed exactly once

  Scenario: The user is told what removing an account really does
    When the user removes an account
    Then the confirmation dialog states that the data of that account will be removed from the device
    And it does not name Google specifically

  Scenario: Automatic sync is explained in plain words
    When the user opens the automatic sync setting
    Then its description states what will be synchronised
