# Proven by: features/privacy/degoogled-defaults.feature

@privacy @requirement
Feature: A freshly flashed device contacts no Google server by default

  Time sync, DNS, captive-portal detection, connectivity checks, address
  lookup, and push registration must all use a non-Google default. A device
  the user has not installed anything additional on must make no request to
  Google infrastructure. This must hold regardless of which future system
  service or default is added — a new default added carelessly is exactly
  the kind of regression this promise exists to catch.

  Rule: Every default system service avoids Google

    Scenario Outline: A system service that used to (or could) reach Google
      Given a freshly flashed device with nothing additional installed
      When the device performs <activity>
      Then it does not contact a Google server

      Examples:
        | activity                          |
        | time synchronisation               |
        | DNS resolution                     |
        | captive-portal detection           |
        | a connectivity/entitlement check   |
        | address lookup from a contact      |

  Rule: Push registration only happens when actually required

    Scenario: No carrier requirement
      Given the SIM's carrier does not require IMS service entitlement over Firebase
      Then no token is requested from Google
