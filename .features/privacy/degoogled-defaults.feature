# Source: vendor/eos overlay/common/frameworks/base/core/res (config_ntpServers,
#         config_default_dns_server, config_enableNetworkLocationOverlay,
#         config_enableFusedLocationOverlay)
# Source: vendor/lineage
#   vendor: overlay: Update default captive portal URLs
#   Add ichnaea & nominatim backends into indicators exempted package list
# Source: packages/apps/Settings, packages/modules/Connectivity
#   Replace cloudfare/google dns with quad9
# Source: packages/services/Telephony
#   Telephony: Use quad9.net for http
# Source: packages/apps/Contacts
#   Contacts: Drop google maps web intent
# Source: packages/apps/Settings
#   Settings: Remove google animations and links
# Source: packages/apps/ImsServiceEntitlement
#   Delay FCM registration until it's actually required

@vendor-eos @privacy @connectivity
Feature: No Google server is contacted by default

  A stock LineageOS build still talks to Google for time (NTP), for DNS, for
  captive-portal detection and for connectivity checks. /e/OS replaces every one
  of those defaults so that a freshly flashed device makes no request to Google
  infrastructure unless the user deliberately installs something that does.

  Background:
    Given a freshly flashed /e/OS device
    And the user has not installed any additional application

  Scenario: Time synchronisation does not use Google
    When the device synchronises its clock
    Then it contacts the NTP pool and not a Google time server

  Scenario: Default DNS is Quad9
    When the device needs a fallback DNS server
    Then it uses 9.9.9.9
    And the hint shown when entering a DNS server manually is 9.9.9.9

  Scenario: Private DNS offers a privacy-respecting provider
    Given LineageOS offers Cloudflare as its one-tap private DNS provider
    When the user opens the private DNS settings on /e/OS
    Then Quad9 is offered in its place
    And selecting it sets the private DNS hostname to "dns.quad9.net"

  Scenario: Captive portal detection does not use Google
    When the device probes for a captive portal
    Then the probe URLs point to /e/ infrastructure and not to Google

  Scenario: Connectivity and entitlement checks do not use Google
    When the telephony stack performs an HTTP reachability check
    Then it targets a non-Google host

  Scenario: Network and fused location providers can be supplied by microG
    When the system looks for a network location provider
    Then a signature-matching provider such as microG's may be installed at runtime
    And the same applies to the fused location provider

  Scenario: Location backends do not trip the privacy indicators
    Given the ichnaea and nominatim location backends are installed
    When they resolve a position on behalf of another application
    Then they do not raise a separate location indicator of their own

  Scenario: Address lookup does not fall back to Google Maps
    When the user taps a postal address in a contact
    Then the device offers the installed maps application
    And it does not open a Google Maps web page

  Scenario: Settings contain no Google links
    When the user browses Settings
    Then no entry links to a Google support page or animation

  Scenario: No Firebase registration unless the carrier needs it
    Given the SIM's carrier does not require IMS service entitlement over Firebase
    When the entitlement service starts
    Then it does not register with Firebase
    And no token is requested from Google
    # LineageOS registers for every user on every carrier.

  Scenario: A carrier that does need it still works
    Given the SIM's carrier requires IMS service entitlement over Firebase
    When the entitlement service starts
    Then it registers for that subscription only
