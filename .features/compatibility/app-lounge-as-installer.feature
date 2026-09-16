# Source: frameworks/base
#   Always return initiating package as the installer package (InstallSourceInfo)
#   pm: Escape user permission for app lounge (PackageInstallerSession)
# Source: vendor/eos config/permissions/eos-allowlist.xml (app-link foundation.e.apps)

@frameworks-base @compatibility @prebuilt-boundary
Feature: App Lounge behaves as the device's application store

  /e/OS installs applications through App Lounge, not through the Play Store.
  Applications that ask "who installed me" — anti-tampering SDKs in banking and
  insurance applications in particular — reject any answer other than a known
  store, and would refuse to run. /e/OS makes the install source consistent so
  those applications accept a device where the store is App Lounge.

  Background:
    Given the device runs /e/OS
    And App Lounge is the preinstalled application store

  Scenario: The install source is self-consistent
    Given an application was installed through App Lounge
    When that application queries its own install source
    Then the initiating package and the installing package are the same
    And an anti-tampering SDK that compares them finds them consistent

  Scenario: Installing from App Lounge does not prompt for every application
    Given the user has allowed App Lounge to install applications
    When App Lounge installs or updates an application
    Then the user is not asked to confirm each individual installation

  Scenario: App Lounge handles its own links
    When a link that belongs to App Lounge is opened
    Then App Lounge handles it without a disambiguation dialog

  Scenario: Other installers are unaffected
    Given the user installs an APK from a file manager
    When the installed application queries its install source
    Then the file manager is reported as the installer
