# Source: external/prebuiltapks/GmsCore/microg.xml
#   the default microG configuration /e/OS ships, applied before first boot
# Source: external/prebuiltapks/GmsCore/privapp-permissions-com.google.android.gms.xml
# Related: compatibility/microg-signature-spoofing.feature (how microG is allowed
#   to present itself), privacy/hide-microg-from-apps.feature (hiding it)
#
# This file states which microG features are ON by default on an /e/OS device.
# It is where the /e/OS privacy posture is most easily misread, so the defaults
# that DO reach Google are stated as plainly as the ones that do not.

@prebuiltapks @compatibility @privacy @prebuilt-boundary
Feature: What microG does out of the box

  microG is configurable, and on a bare installation almost everything is off.
  /e/OS ships it preconfigured, because a device whose push notifications and
  in-app purchases do not work is not a device most people can use. Those
  choices are /e/OS's, not microG's, and several of them do mean the device
  talks to Google.

  Background:
    Given a freshly flashed /e/OS device
    And the user has not changed any microG setting

  Rule: Push and account features are on, and they reach Google

    Without these, applications that rely on Google's push service receive no
    notifications at all. This is the deliberate trade-off at the heart of
    /e/OS's compatibility story.

    Scenario: Cloud messaging
      Then Google Cloud Messaging is enabled
      And applications relying on it receive their push notifications

    Scenario: Device check-in
      Then device check-in is enabled

    Scenario: Talking to Google is not routed through Tor
      Then requests to Google are made directly
      And Tor routing is off

    Scenario: Google accounts can be added
      Then the account manager accepts Google accounts
      And two-step verification is supported

  Rule: Integrity checks are answered

    Scenario: SafetyNet and DroidGuard
      Then SafetyNet is enabled
      And DroidGuard is enabled
      # What the platform does to make them pass:
      # compatibility/play-integrity-compat.feature

  Rule: Location does not go to Google

    This is where /e/OS diverges from a default microG installation: position
    resolution is served by an open database, and reverse geocoding by an open
    service.

    Scenario: Network location source
      Then Wi-Fi and cell positioning are enabled
      And they resolve against the configured open location database
      And not against Google's location service

    Scenario: Reverse geocoding
      Then addresses are resolved through the open geocoder

    Scenario: The device improves its own positioning locally
      Then Wi-Fi and cell learning are enabled
      And moving-network detection is enabled

  Rule: Store features work without the Play Store

    Scenario Outline: In-app functionality backed by microG
      Then <feature> is enabled

      Examples:
        | feature                        |
        | application licence checking   |
        | acquiring free applications    |
        | in-app billing                 |
        | asset delivery                 |
        | split installs                 |
        | device synchronisation         |

  Rule: microG holds privileged permissions

    Scenario: The allowlist is explicit
      Then microG is allowlisted for installing a location provider, modifying phone state, scanning networks and leaving the idle allowlist
      And the allowlist is a file in the build, reviewable like any other change

    Scenario: The store stub holds a narrower set
      Then the store stub is allowlisted only for signature spoofing, installing and deleting packages, network access and notification naming
