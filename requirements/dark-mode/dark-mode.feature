# Proven by: (none yet)

@dark-mode @requirement
Feature: A system-wide dark mode is available and respected

  The user can switch the system to a dark theme, and the system UI and
  preinstalled applications honour it consistently rather than leaving some
  screens stuck in a light theme.

  Rule: Dark mode is consistent across the system

    Scenario: The user turns dark mode on
      Given the user has enabled dark mode
      Then the system UI uses the dark theme
      And every preinstalled application does too

  # No features/ file proves this yet.
