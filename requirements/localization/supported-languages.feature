# Proven by: (none yet)

@localization @requirement @P-3
Feature: The system is usable in at least English, French, Spanish, German, and Italian

  The system UI and every preinstalled application are fully translated in
  at least these five languages. This is a floor, not a target — additional
  languages may be supported, but these five must never regress to a
  partial or missing translation.

  Rule: The minimum set is never regressed

    Scenario Outline: A minimum-supported language stays complete
      Given the device is set to <language>
      When the user navigates the system UI and the preinstalled applications
      Then no untranslated string is shown

      Examples:
        | language |
        | English  |
        | French   |
        | Spanish  |
        | German   |
        | Italian  |

  # No features/ file proves this yet.
