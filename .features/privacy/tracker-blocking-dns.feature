# Source: packages/modules/DnsResolver
#   dnsresolver: use dns blocker app to filter trackers
#   dnsresolver: Adapt for Unix socket
#   DnsResolver: Change socket name
#   shouldBlockRequest: Don't block if socket connect fails
# Source: device/lineage/sepolicy
#   sepolicy: Add rules for tracker blocker

@dnsresolver @privacy @sepolicy @prebuilt-boundary
Feature: System-wide tracker blocking at DNS resolution

  LineageOS resolves every hostname an application asks for. /e/OS routes each
  resolution through the Advanced Privacy app, which can veto it, so trackers
  can be blocked for *every* application on the device — including applications
  that ship their own networking stack — without a VPN and without root.

  The decision itself belongs to Advanced Privacy (own repository). What is
  specified here is the system-side contract: the resolver asks, and honours
  the answer.

  Background:
    Given the device runs /e/OS
    And the tracker-blocker service listens on the abstract unix socket "foundation.e.advancedprivacy"

  Scenario: A blocked hostname never reaches a DNS server
    Given the tracker blocker is configured to block "tracker.example.com" for the calling application
    When the application resolves "tracker.example.com"
    Then the resolver asks the tracker blocker about "tracker.example.com" together with the calling UID
    And the tracker blocker answers something other than "pass"
    And the resolution is rewritten to "localhost"
    And no DNS query for "tracker.example.com" leaves the device

  Scenario: An allowed hostname resolves normally
    Given the tracker blocker is configured to allow "api.example.com" for the calling application
    When the application resolves "api.example.com"
    Then the tracker blocker answers "pass"
    And the resolution proceeds against the configured DNS servers

  Scenario: Blocking is decided per application
    Given the tracker blocker blocks "metrics.example.com" for application "com.example.one"
    And the tracker blocker allows "metrics.example.com" for application "com.example.two"
    When "com.example.one" resolves "metrics.example.com"
    Then the resolution is rewritten to "localhost"
    When "com.example.two" resolves "metrics.example.com"
    Then the resolution proceeds against the configured DNS servers

  Rule: Name resolution must never depend on the blocker being up

    The resolver runs before and independently of the Android framework; a
    blocker that is absent, starting, crashed or uninstalled must degrade to
    "allow", never to "no connectivity".

    Scenario: The tracker blocker is not running
      Given nothing is listening on the tracker-blocker socket
      When an application resolves any hostname
      Then the resolver does not block the resolution
      And connectivity check probes succeed

    Scenario: The tracker blocker does not answer
      Given the tracker-blocker socket accepts the connection but sends no reply
      When an application resolves any hostname
      Then the resolver does not block the resolution

    Scenario: Resolution during early boot
      Given the device has just booted and the tracker blocker has not started yet
      When the connectivity service resolves the captive portal URL
      Then the resolution succeeds
      And the resolver configuration is applied without error

  Scenario: The blocker is reachable from a sandboxed platform app
    Given the tracker blocker runs as a platform application
    Then SELinux allows it to create and listen on the unix socket used by the resolver
