# Source: vendor/lineage
#   Bump security string to <month> (monthly, ahead of LineageOS)
#   version: Bump to /e/OS vX.Y
# Source: ~40 forked projects carrying Android Security Bulletin backports
#   (frameworks/base, frameworks/av, packages/modules/Bluetooth,
#    packages/modules/Nfc, external/libpng, external/freetype, …)
# Source: packages/apps/LineageParts
#   LineageParts: Change references to /e/ OS in Trust ASB dialog

@vendor-lineage @updates @security
Feature: Monthly security patch level

  /e/OS backports the monthly Android Security Bulletin into its own forks
  rather than waiting for them to reach the LineageOS branches, and advertises
  the corresponding patch level. This is the reason most /e/OS forks exist at
  all, and it is what the security indicator in the settings reflects.

  Background:
    Given the device runs an /e/OS build whose release type has a published channel
    # Release types: updates/release-types.feature

  Scenario: The advertised patch level matches the bulletin that was merged
    When the user opens "About phone"
    Then the Android security patch level is the month whose bulletin has been merged into the build

  Scenario: The security indicator is /e/OS-branded
    When the user opens the security patch information dialog
    Then it refers to /e/OS and not to LineageOS

  Scenario: The /e/OS version is shown alongside the Android version
    When the user opens "About phone"
    Then the /e/OS version is displayed
    And the underlying Android version is displayed

  Scenario: A monthly release carries the month's bulletin
    Given a monthly /e/OS release
    Then the fixes of that month's Android Security Bulletin are present in the forked projects
    And the security patch string is bumped in the same release

  Scenario: The bulletin is the same across release types
    Given an official build and a community build cut from the same release
    Then both carry the same Android Security Bulletin backports
    And both advertise the same security patch level
    And they differ only in what the release type itself gates
