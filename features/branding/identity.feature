# Source: vendor/lineage
#   vendor: Set /e/ package name & version on builds
#   version: Bump to /e/OS vX.Y
#   Add our own bootanimation
#   Update default wallpaper / Update default wallpaper in overlay
#   Add tablet package for wallpapers / overlay: Update wallpapers for tablet product
#   vendor/lineage: Change emulator name
#   vendor: config: Include configuration for eos
#   build/envsetup.sh: derive LINEAGE_BUILD from e_ prefixed products too
# Source: packages/apps/Backgrounds
#   Add phone wallpapers / Add tablet wallpapers / Convert wallpapers to webp
# Source: vendor/eos config/common_mobile.mk, config/telephony.mk
#   default notification, alarm and ringtone sounds
#   products/e_sdk_phone_x86_64.mk: e_sdk_phone_x86_64 emulator product
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

  @BRAND-1
  Scenario: Boot
    When the device boots
    Then the /e/OS boot animation is shown
    And no LineageOS animation is shown

  @BRAND-2
  Scenario: The build identifies itself as /e/OS
    When the user opens "About phone"
    Then the /e/OS version is shown
    And the build description names /e/OS
    And the version string names the release type
    # The release-type vocabulary: updates/release-types.feature

  @BRAND-3
  Scenario: Wallpapers and sounds are /e/OS ones
    Given a freshly flashed device
    Then the default wallpaper is the /e/OS one
    And the default ringtone is "Dione.ogg"
    And the default notification sound is "Selenium.ogg"
    And the default alarm sound is "Platinum-old.ogg"
    And the camera shutter and recording sounds are the /e/OS ones

  @BRAND-4
  Scenario: Tablets get their own wallpapers
    Given the device is a tablet
    Then the wallpaper set shipped is the tablet one

  @BRAND-5
  Scenario: Wallpapers do not bloat the image
    Then the shipped wallpapers are stored in a compressed format

  @BRAND-6
  Scenario: The emulator build identifies itself as /e/OS
    Given the build target is the /e/OS emulator product
    When the product is selected with lunch
    Then the product name is "e_sdk_phone_x86_64"
    And the product model is "/e/OS emulator x86_64"
    And the version string keeps its device suffix
    # A product name that does not start with "lineage_" must still yield a
    # non-empty LINEAGE_BUILD: an empty one drops the device suffix from
    # LINEAGE_VERSION and from ro.lineage.device, and the envsetup guards of
    # the form `getprop ro.lineage.device | grep -q "$LINEAGE_BUILD"` then
    # match any device.

  @BRAND-7
  Scenario: A running /e/OS emulator is distinguishable from a LineageOS one
    Given an /e/OS emulator and a LineageOS emulator are running side by side
    When the host lists the attached devices
    Then each reports its own product name
    And the /e/OS one reports "e_sdk_phone_x86_64"
    # The reported device stays "emu64x" on both: it comes from PRODUCT_DEVICE
    # in device/generic/goldfish, which /e/OS consumes from LineageOS rather
    # than forks.

  @BRAND-8
  Scenario: No LineageOS string is left in the user interface
    When the user browses the system applications
    Then no screen shows the LineageOS name or logo
