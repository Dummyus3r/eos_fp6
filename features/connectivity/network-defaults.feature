# Source: packages/modules/Connectivity
#   Replace google dns with quadnine dns
# Source: packages/apps/Settings
#   Replace cloudflare with quad9 as dns provider
#   Settings: Change ping to quad9 dns
# Source: vendor/eos overlay (SettingsLib wifi_dns hints, wifi scan throttle exceptions)
# Source: frameworks/base
#   AndroidManifest.xml: Specify broadcast for NETWORK_COUNTRYCODE_UPDATED

@connectivity @privacy
Feature: Network defaults

  Complements privacy/degoogled-defaults.feature with the connectivity-side
  defaults.

  Background:
    Given the device runs /e/OS

  @NET-6
  Scenario: The one-tap private DNS provider is Quad9
    Given LineageOS offers Cloudflare
    When the user opens the private DNS settings on /e/OS
    Then the offered provider is Quad9
    And no Cloudflare entry remains

  @NET-7
  Scenario: Tethered clients are given Quad9
    When the device shares its connection
    Then the DNS servers handed to the tethered clients are Quad9's

  @NET-8
  Scenario: Connectivity diagnostics do not use Google
    When the settings run a reachability test
    Then the test targets Quad9

  @NET-9
  Scenario: Manual DNS entry suggests Quad9
    When the user enters a DNS server for a Wi-Fi network
    Then the suggested value is 9.9.9.9

  @NET-10
  Scenario: The location backend can scan Wi-Fi often enough to be useful
    Given the ichnaea location backend is installed
    When it scans for Wi-Fi networks
    Then it is exempt from the foreground and background scan throttling
