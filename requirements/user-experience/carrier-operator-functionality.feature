# Proven by: (none yet — related but distinct: features/connectivity/*.feature specify
#            default APN/network values, not the promise that carrier-provided
#            services keep working)

@user-experience @requirement
Feature: Carrier and operator services keep working

  Calls, SMS, MMS, visual voicemail, RCS and carrier-specific provisioning
  must keep working the way the user's operator expects, across operators
  /e/OS is not specifically tested against.

  # No features/ file proves this at the promise level yet. Scenarios are to
  # be written once this is broken down into concrete specs.
