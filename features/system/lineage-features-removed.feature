# Source: packages/apps/LineageParts
#   LineageParts: Remove LineageOS stats collection support completely
#   LineageParts: Add /e/ contributors
#   LineageParts: Change references to /e/ OS in Trust ASB dialog
#   LineageParts: Add openkeychain
#   feat: rename "microG" into "App compatibility"
# Source: vendor/lineage
#   lineage: Drop lineage otacert
#   vendor: lineage: remove nfc and fingerprint help url
#   Do not ship addon.d/50-lineage.sh anymore
#   vendor/lineage: Drop partner gms makefiles
#   vendor: Exclude AudioFX by default
# Source: packages/apps/Settings
#   Settings: Change updater summary for /e/OS version
# Source: build/soong
#   soong: Use our keys for otacerts if it exists
# Source: packages/apps/ThemePicker
#   ThemePicker: Remove wallpaper color selection

@lineageparts @vendor-lineage @system
Feature: LineageOS-specific surfaces are replaced by /e/OS ones

  A LineageOS fork that keeps LineageOS branding, LineageOS update keys and
  LineageOS support links confuses users and breaks updates. /e/OS removes them.

  Background:
    Given the device runs /e/OS

  @SYS-16
  Scenario: Updates are signed by /e/OS
    Then the LineageOS OTA certificate is not shipped
    And the /e/OS signing keys are used for the OTA certificates

  @SYS-17
  Scenario: Support links point at /e/OS
    When the user opens the NFC or fingerprint help
    Then no LineageOS help page is offered
    And the permission help links to the /e/OS community

  @SYS-18
  Scenario: Contributors and legal notices name /e/OS
    When the user opens the contributors list
    Then /e/OS contributors are listed

  @SYS-19
  Scenario: The security dialog names /e/OS
    When the user opens the security patch dialog
    Then it refers to /e/OS

  @SYS-20
  Scenario: The microG entry is named for what it does
    When the user browses the /e/OS settings
    Then the microG settings entry is labelled "App compatibility"

  @SYS-21
  Scenario: An OpenPGP key manager is offered
    Then OpenKeychain is available from the /e/OS settings

  @SYS-22
  Scenario: LineageOS add-on survival scripts are not shipped
    Then no LineageOS addon.d survival script is present in the image

  @SYS-23
  Scenario: Google partner makefiles are not used
    Then no partner GMS makefile is inherited by the build

  @SYS-24
  Scenario: Wallpaper-driven colour selection is removed from the theme picker
    When the user opens the theme picker
    Then no wallpaper colour selection is offered
