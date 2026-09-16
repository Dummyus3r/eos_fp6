# Source: vendor/lineage
#   vendor: Set /e/ package name & version on builds
#   version: Bump to /e/OS vX.Y
#   Add our own bootanimation
#   Update default wallpaper / Update default wallpaper in overlay
#   Add tablet package for wallpapers / overlay: Update wallpapers for tablet product
#   vendor/lineage: Change emulator name
#   vendor: config: Include configuration for eos
# Source: packages/apps/Backgrounds
#   Add phone wallpapers / Add tablet wallpapers / Convert wallpapers to webp
# Source: vendor/eos config/common_mobile.mk, config/telephony.mk
#   default notification, alarm and ringtone sounds
# Source: frameworks/base
#   base: sounds: Change camera click/stop/record sounds
# Source: build/soong
#   Change build description in Settings > About Phone
# Source: packages/apps/SetupWizard, packages/apps/Updater, …
#   Replace lineage strings and logo with /e/

@vendor-lineage @branding
Feature: The device presents itself as /e/OS

  A user who flashes /e/OS should see /e/OS, not LineageOS with a different
  application set — from the boot animation to the build fingerprint.

  Background:
    Given the device runs /e/OS

  Scenario: Boot
    When the device boots
    Then the /e/OS boot animation is shown
    And no LineageOS animation is shown

  Scenario: The build identifies itself as /e/OS
    When the user opens "About phone"
    Then the /e/OS version is shown
    And the build description names /e/OS

  Scenario: Wallpapers and sounds are /e/OS ones
    Given a freshly flashed device
    Then the default wallpaper is the /e/OS one
    And the default ringtone, notification sound and alarm sound are the /e/OS ones
    And the camera shutter and recording sounds are the /e/OS ones

  Scenario: Tablets get their own wallpapers
    Given the device is a tablet
    Then the wallpaper set shipped is the tablet one

  Scenario: Wallpapers do not bloat the image
    Then the shipped wallpapers are stored in a compressed format

  Scenario: No LineageOS string is left in the user interface
    When the user browses the system applications
    Then no screen shows the LineageOS name or logo
