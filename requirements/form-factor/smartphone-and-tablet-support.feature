# Proven by: (none yet)

@form-factor @requirement @R-2
Feature: The system works on both smartphones and tablets, in portrait and tablet orientation

  The UI adapts to the device's form factor: a smartphone in portrait, and a
  tablet with a layout that takes advantage of the extra space rather than
  stretching the phone layout.

  Rule: The layout adapts to the form factor

    Scenario: Smartphone, portrait
      Given the device is a smartphone
      Then the system UI is laid out for a single-column, portrait experience

    Scenario: Tablet
      Given the device is a tablet
      Then the system UI uses a layout suited to the larger screen, not a
      stretched phone layout

  # No features/ file proves this yet.
