# Proven by: (none yet)

@sustainability @requirement @R-9
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

  Rule: A community device without a newer Android version keeps getting OTA updates for as long as its version is supported

    A community device with no upgrade path stays on its Android version and
    keeps receiving regular OTA updates on it for exactly as long as /e/OS
    supports that Android version — the same duration as the general rule
    above, not a separate, shorter community cutoff.

    Scenario: No newer Android version exists for this model
      Given a community device model with no newer Android version available
      Then it keeps receiving OTA updates for as long as /e/OS supports its
      Android version, per the rule above

  Rule: When a newer Android version becomes available for a community device, the old one is retired after a transition period

    Community devices do not receive an Android-version upgrade over the
    air — the user migrates manually, unlike an official device. Once a
    newer Android version is supported for a given model, /e/OS makes that
    build available; the previous version's builds are not stopped
    immediately, but after a transition period long enough for users to
    make that manual move.

    Scenario: A newer Android version becomes available
      Given a community device model that gains support for a newer Android version
      Then a build of that newer version is made available for the model
      And the previous version's builds keep being published, for now

    Scenario: The transition period ends
      Given a community device model whose newer Android version has been available for the length of the transition period
      Then builds of the previous Android version stop for that model
