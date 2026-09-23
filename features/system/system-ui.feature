# Source: frameworks/base
#   SystemUI: Theme according to our palette / Theme system components according to our palette
#   SettingsLib: Theme according to our palette / replace compose switch with our own
#   Add e colors and e switch
#   Remove wallet tile
#   core/res config_keyguardQuickAffordanceDefault: bottom_end wallet -> none
#   Remove partial screenshot from recents
#   SystemUI: change intent for viewing screenshots
#   keyguard: Keep SIM card name visible during PIN entry
#   fix light mode 3 button navigation
#   SystemUI: apply light/dark theme to shade header elements
#   SystemUI: Follow light/dark theme in quick settings / power menu / SplitShade header
#   SystemUI: Add dual-tone light and dark themes for QS
#   SystemUI: Re-evaluate system theme on UI mode change / Recreate overlays anyway
#   Don't create dynamic overlay
#   PhoneStatusBarView: Pad statusbar with Launcher3 dock width
#   fix: long pressing notifications crashing SystemUI
#   fix color of emphasized notification / Update legacy autofill bottomsheet
# Source: vendor/eos overlay (flag_monet=false -> Material You / Monet off, launcher_overlayable_package,
#   config_defaultListenerAccessPackages, config_longPressOnAppSwitchBehavior)
# Source: packages/apps/LineageParts
#   Remove split screen option from recents long press actions
# Source: vendor/lineage
#   Disable private space

@frameworks-base @lineageparts @vendor-eos @system
Feature: System UI follows the /e/OS design

  LineageOS keeps the AOSP system UI, including Material You dynamic colours
  driven by the wallpaper. /e/OS applies a fixed, deliberate palette instead,
  and removes the surfaces that only make sense with Google services.

  Background:
    Given the device runs /e/OS

  @SYS-48
  Scenario: Colours are the /e/OS palette, not the wallpaper's
    Then Material You dynamic colour (Monet) is disabled
    And the wallpaper does not influence the system colours
    And the quick settings, the shade, the power menu and the keyguard use the /e/OS palette

  @SYS-49
  Scenario: The /e/OS accent is the system accent
    Then the system primary and accent colours resolve to the /e/OS accent
    And the accent is "#0086FF" in the light theme
    And it is "#5DB2FF" in the dark theme
    And an application that reads the platform accent gets the same value

  @SYS-50
  Scenario: Light and dark themes are both complete
    When the user switches between the light and the dark theme
    Then the quick settings, the shade header, the power menu and the navigation bar follow the change
    And no element keeps the colours of the previous theme

  @SYS-51
  Scenario: The theme survives a configuration change
    When the display mode or the screen layout changes
    Then the quick settings and the status bar are re-evaluated
    And they do not crash or lose their theming

  @SYS-52
  Scenario: Dark mode is not forced on a new device
    Given a freshly flashed device
    Then the system is in light mode until the user chooses otherwise

  @SYS-53
  Scenario: Google-specific surfaces are removed
    Then no wallet tile is offered in the quick settings
    And the lock screen carries no wallet shortcut
    And private space is not offered

  @SYS-54
  Scenario: Screenshots open in the /e/OS gallery
    When the user taps a screenshot notification
    Then the /e/OS gallery opens it

  @SYS-55
  Scenario: Partial screenshot is not offered from recents
    When the user opens the recents screen
    Then no partial screenshot action is offered
    And no split screen action is offered when long-pressing an application icon

  @SYS-56
  Scenario: The launcher is the system's notification listener
    Then BlissLauncher is allowed to read notifications so it can show badges
    And the status bar accounts for the launcher's dock width

  @SYS-57
  Scenario: Long pressing the app switch key does nothing by default
    When the user long-presses the app switch key
    Then no action is triggered unless the user has configured one

  @SYS-58
  Scenario: The SIM name stays readable while unlocking
    Given the device has a SIM with a PIN
    When the user enters the SIM PIN
    Then the name of the SIM card remains visible
