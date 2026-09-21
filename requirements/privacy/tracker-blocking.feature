# Proven by: features/privacy/tracker-blocking-dns.feature

@privacy @requirement
Feature: A blocked tracker never reaches the network

  When the tracker blocker has decided to block a hostname for an
  application, no request for that hostname leaves the device — for every
  application, including ones with their own networking stack, without a VPN
  and without root. And the reverse must hold too: the blocker being absent,
  crashed, or not yet started must never itself cut connectivity.

  Rule: Blocking is enforced for every application

    Scenario: A blocked hostname
      Given the tracker blocker has decided to block a hostname for the calling application
      When that application resolves the hostname
      Then no query for it leaves the device

  Rule: The blocker failing must degrade to "allow", never to "no connectivity"

    Scenario: The blocker is not running
      Given the tracker blocker is absent, crashed, or has not started yet
      When any application resolves any hostname
      Then the resolution is not blocked
      And connectivity is not affected
