# Proven by: features/privacy/telemetry.feature
# Known exception: features/updates/ota-updater.feature — the OTA update check
# carries a random, anonymous identifier (not a device identifier), reset on
# factory reset, used only to count installs. Whether this is compatible with
# the GDPR audience-measurement exemption (which requires clear user
# information and an opt-out, neither of which exists today) is an open
# question — not decided here.

@privacy @requirement @R-5
Feature: No telemetry is ever sent without the user's consent

  /e/OS collects no usage statistics, and sends no crash report, unless the
  user has explicitly turned that on. This must hold regardless of which
  future feature or integration is added — nothing on the device should ever
  start reporting data by default, or because a default silently changed.

  The one known exception is the OTA update check's anonymous install
  counter (see above): it predates this requirement and is not covered by
  it until the open question above is resolved.

  Rule: There is nothing to opt out of, only something to opt in to

    Scenario: A freshly set up device
      Given a device that has just been through first-time setup
      Then no usage statistics have ever been uploaded from it
      And crash reporting is off

    Scenario: The user has not made a choice
      Given the user has not touched the telemetry setting
      Then no statistics or crash report is sent
