# Source: packages/inputmethods/LatinIME
#   LatinIME: Add icon on the keyboard to access STT feature
#   feat(stt): target the offline STT keyboard and drop premium gating
#   Rename the floating button to the STT button
#   Show mic on the strip when suggestions are disabled
#   Enable emoji key by default for old and new users
#   3736-Q-Set_voice_input_key_preference_default_false
#   LatinIME: Reload theme on configuration change / Retheme app according to new base
#   LatinIME: add elib
#   LatinIME: Add OLED theme, clipboard paste key, number row tweaks,
#     slide-to-delete (upstream contributions carried by /e/OS)
# Source: external/prebuiltapks MurenaVoiceToTextOffline
# Source: vendor/eos config/permissions (foundation.e.stt)

@latinime @system @prebuilt-boundary
Feature: Keyboard with on-device speech to text

  The AOSP keyboard's voice key goes to a cloud speech service. /e/OS routes it
  to an on-device speech-to-text engine instead, so dictation works without
  sending audio anywhere, and it is available to every user rather than gated.

  Background:
    Given the device runs /e/OS
    And the offline speech-to-text engine is preinstalled

  Scenario: Dictation uses the on-device engine
    When the user taps the speech-to-text button on the keyboard
    Then the offline speech-to-text keyboard is opened
    And no audio leaves the device

  Scenario: Dictation is available to everyone
    Then the speech-to-text button is not gated behind a paid plan

  Scenario: The cloud voice key is off by default
    Given a freshly flashed device
    Then the cloud voice input key is disabled

  Scenario: The speech-to-text button is reachable when suggestions are off
    Given the user has disabled word suggestions
    When the keyboard is shown
    Then the speech-to-text button is shown on the suggestion strip

  Scenario: The emoji key is available by default
    Given a freshly flashed device
    Then the emoji key is enabled
    Given a device updated from an earlier /e/OS release
    Then the emoji key is enabled

  Scenario: The keyboard follows the system theme
    When the system switches between light and dark
    Then the keyboard is re-themed accordingly without being restarted

  Scenario: The engine holds the permissions it needs
    Then the speech-to-text engine already holds the microphone permission
