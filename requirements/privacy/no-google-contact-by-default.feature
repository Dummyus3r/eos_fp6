# Proven by: features/privacy/degoogled-defaults.feature,
#            features/compatibility/microg-configuration.feature

@privacy @requirement
Feature: A freshly flashed device contacts no Google server by default

  Time sync, DNS, captive-portal detection, connectivity checks, address
  lookup, location resolution, and push registration must all use a
  non-Google default. A device the user has not installed anything
  additional on must make no request to Google infrastructure. This must
  hold regardless of which future system service, default, or microG
  configuration change is made — a new default added carelessly is exactly
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

  Rule: Location resolution never goes through Google either

    microG provides the push and account features that make Google-dependent
    applications usable, but its location resolution is deliberately
    reconfigured on top of microG's own defaults to avoid Google.

    Scenario: Network location
      When the device resolves Wi-Fi or cell-based position
      Then it resolves against an open location database
      And not against Google's location service

    Scenario: Reverse geocoding
      When an address is resolved from coordinates
      Then it goes through an open geocoding service

  Rule: Push registration only happens when actually required

    Scenario: No carrier requirement
      Given the SIM's carrier does not require IMS service entitlement over Firebase
      Then no token is requested from Google
