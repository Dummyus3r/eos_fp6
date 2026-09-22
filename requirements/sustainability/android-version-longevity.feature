# Proven by: (none yet)
# Community-device policy: pending decisions, see below — not yet a promise.

@sustainability @requirement
Feature: A device is kept secure and current for as long as reasonably possible

  /e/OS extends a smartphone's usable life well past what the original
  manufacturer or Google commits to, on two related but distinct axes: how
  long a given Android version keeps receiving security patches, and how
  long a given device keeps being migrated to newer Android versions.

  Rule: An Android version receives security patches as long as Google does, then best-effort backports

    /e/OS follows Google's own AOSP security-patch support window for a given
    Android version. Once that window ends, /e/OS may keep offering that
    Android version, backporting security patches on a best-effort basis
    where technically possible — this is not a guaranteed continuation, and
    a device on that version should not be presented as receiving the same
    guarantee as one still inside Google's support window.

    Scenario: Inside Google's support window
      Given an Android version still receiving AOSP security patches from Google
      Then every device shipping that version keeps receiving those patches

    Scenario: After Google's support window ends
      Given an Android version no longer receiving AOSP security patches from Google
      When a patch can technically be backported to it
      Then /e/OS may still deliver it, on a best-effort basis
      And this is not represented as an ongoing guarantee

  Rule: Official devices are migrated beyond the EU legal minimum, as far as technically possible, delivered over the air

    For officially supported devices, /e/OS commits to going beyond the
    minimum device-support duration required by EU regulation (see the EU
    Ecodesign requirements for smartphones — exact figures not verified
    here). An official device is migrated to newer Android versions for as
    long as no technical obstacle prevents it, not just for the legally
    required minimum — and that migration is delivered as an OTA update, not
    something the user has to flash manually.

    Scenario: A newer Android version is technically portable
      Given an officially supported device with no technical obstacle to a newer Android version
      Then /e/OS ports it to that newer version
      And the port is delivered to the device as an OTA update

    Scenario: A technical obstacle appears
      Given an officially supported device that cannot technically be ported further
      Then migration stops there
      And the device falls back to the security-patch rule above

  Rule: Community-device policy — decision pending, not yet a promise

    Two related decisions are still open and unresolved as of this writing;
    until they are decided, this file makes no promise about community
    devices beyond what the two rules above already say in general terms.
    One thing is already settled, though, and is not part of the pending
    decisions: community devices do not receive Android-version upgrades
    over the air — the OTA-delivery commitment above is specific to official
    devices, and a community-device user migrates manually.

    - How long a community device with **no** newer Android version
      available keeps receiving builds/patches:
      https://gitlab.e.foundation/e/devices/backlog/-/work_items/2036
    - How long a community device **with** a newer Android version available
      keeps receiving builds on its current version before migration is
      required:
      https://gitlab.e.foundation/e/devices/backlog/-/work_items/2037

    Once decided, this rule should be replaced by the actual commitment, not
    merely annotated.
