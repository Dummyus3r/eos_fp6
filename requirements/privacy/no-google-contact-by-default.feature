# Proven by: features/privacy/degoogled-defaults.feature,
#            features/compatibility/microg-configuration.feature
# The third-party-app push registration rule below is verified directly
# against e/os/GmsCore source (PushRegisterService.kt, GcmPrefs.kt), not yet
# captured in any features/ file.

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

  Rule: IMS service entitlement registration only happens when the carrier requires it

    This is the system's own Firebase registration, for carrier IMS
    entitlement checks — distinct from the rule below, which is about
    third-party applications.

    Scenario: No carrier requirement
      Given the SIM's carrier does not require IMS service entitlement over Firebase
      Then no token is requested from Google

  Rule: A third-party app's push registration only happens because that app asked for it

    microG never registers an application for push notifications on its own;
    registration is per calling package, triggered only by that package's own
    request. By default, a new app is registered without a confirmation
    prompt — the user can turn on a per-app confirmation step in microG's
    advanced settings, but it is off by default.

    Scenario: An installed application asks for push notifications
      Given a third-party application calls the push-registration API
      Then microG registers that application specifically
      And no other application is registered as a side effect

    Scenario: Nothing asks for it
      Given no application has requested push registration
      Then microG registers nothing on its own
