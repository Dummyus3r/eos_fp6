# Source: packages/apps/{Contacts,Dialer,DocumentsUI,Settings,SettingsIntelligence,
#         FMRadio,Gallery2,ThemePicker,WallpaperPicker2,Updater,LatinIME,LineageParts,
#         Permission}
#   Change app icon to our custom icon / Update app icon according to new design
#   Theme app according to our palette
# Source: packages/apps/elib (shared /e/OS UI library)
# Source: vendor/eos overlay/no-rro/external/setupdesign
# Source: packages/overlays/Lineage
#   overlays: Add circle icon overlay

@branding @apps
Feature: One visual identity across the system applications

  LineageOS ships each application with its own AOSP or LineageOS look. /e/OS
  restyles all of them against a single palette and icon set, shared through the
  `elib` library, so the device looks like one product rather than a collection
  of forks.

  Background:
    Given the device runs /e/OS

  Scenario Outline: System applications carry the /e/OS identity
    When the user opens <application>
    Then its colours follow the /e/OS palette in both light and dark themes
    And its launcher icon is the /e/OS one

    Examples:
      | application        |
      | Contacts           |
      | the Dialer         |
      | Files              |
      | Settings           |
      | the Gallery        |
      | the FM radio       |
      | the updater        |
      | the keyboard       |
      | the permission UI  |

  Scenario: The shared UI library provides the common components
    Then switches, colours and common icons come from the shared /e/OS UI library
    And the same component looks the same in every application

  Scenario: The setup screens use the /e/OS palette
    When any screen built on the setup design library is shown
    Then it uses the /e/OS colours in light and dark themes

  Scenario: Icon shape is consistent
    Then adaptive icons are masked to the /e/OS shape
