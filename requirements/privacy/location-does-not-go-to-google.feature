# Proven by: features/compatibility/microg-configuration.feature

@privacy @requirement
Feature: Location resolution never goes through Google

  microG provides the push and account features that make Google-dependent
  applications usable, but its location resolution must be served by open
  services, not by Google's location service — this is /e/OS's own choice on
  top of microG's defaults, and it must survive any future change to how
  microG is configured.

  Rule: Position resolution uses open services

    Scenario: Network location
      When the device resolves Wi-Fi or cell-based position
      Then it resolves against an open location database
      And not against Google's location service

    Scenario: Reverse geocoding
      When an address is resolved from coordinates
      Then it goes through an open geocoding service
