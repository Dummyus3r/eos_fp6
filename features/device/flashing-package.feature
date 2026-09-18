# Source: vendor/eos/flash
#   Android.mk           — builds IMG-e-<version>.zip, hooked onto `bacon`
#   factory.common       — the shared flashing logic
#   <device>/config.mk   — which images go into the package, per device
#   <device>/flash_<device>_factory.sh — per-device parameters
#   fastboot/bin-linux-x86, bin-darwin, bin-msys — bundled fastboot binaries
# Devices with a flashing package today: FP3, FP4, FP5, FP6, GS6_Venus, avicii,
#   axolotl, emerald, mimir, otter, panther, redfin, rigby, sapphire, shiba,
#   tetris, two, zirconia

@vendor-eos @device @flashing @device-specific
Feature: Self-contained flashing package for manual installation

  LineageOS expects the user to find the right fastboot, read a wiki page and
  type the commands themselves. /e/OS is installed by people who bought a phone,
  not by ROM developers, and it is also installed on devices whose flashing
  sequence is genuinely intricate. So an /e/OS build produces a single archive
  that carries the images, a script that knows the device's flashing sequence,
  and a fastboot binary for each desktop operating system.
  A flashing package exists only for a device that has a flashing configuration,
  and the sequence is that device's own.


  Background:
    Given an /e/OS build for a device that has a flashing configuration

  Scenario: The build produces a flashable archive
    When the release artefacts are built
    Then an image package archive is produced alongside the OTA package
    And it is named after the /e/OS version
    And an MD5 and a SHA-256 checksum are produced next to it

  Scenario: The archive is self-contained
    Then it contains the partition images the device needs
    And it contains the device's flashing script
    And it contains a fastboot binary for GNU/Linux, for macOS and for Windows
    And the user does not have to install the Android platform tools

  Scenario: The script picks the right fastboot for the host
    When the user runs the flashing script
    Then the bundled fastboot for the host operating system is used
    And an unsupported operating system is reported and the script stops

  Scenario: The script waits for the right device
    Given several devices are connected
    When the user runs the flashing script
    Then only a device whose fastboot product string matches the target is selected
    And the script waits until such a device appears

  Rule: The script refuses to run rather than half-flash a device

    Scenario: The bootloader is still locked
      Given the device bootloader is locked
      When the user runs the flashing script
      Then the script reports that the bootloader must be unlocked first
      And it flashes nothing

    Scenario: Critical partitions are still locked
      Given the device requires critical partitions to be unlocked
      And they are locked
      When the user runs the flashing script
      Then the script tells the user to run the critical unlock first
      And it flashes nothing

    Scenario: A partition fails to flash
      Given a partition cannot be written
      When the failure occurs
      Then the script stops
      And it tells the user how to get back into fastboot mode and start again

  Scenario: The device's own flashing sequence is respected
    Then the firmware images are flashed to both slots where the device requires it
    And the device is rebooted into the bootloader between the firmware and the system images
    And it is switched into fastbootd when the device requires it for the logical partitions

  Scenario: A clean flash wipes what it must
    Given the device configuration asks for a clean flash
    Then the user data and metadata partitions are erased
    And the super partition is wiped before the logical partitions are written

  Scenario: The rollback index is reset where the device supports it
    Given the device configuration asks for a rollback index reset
    When the script runs
    Then the reset is attempted
    And the script continues when the device does not implement the command

  Scenario: The device reboots into /e/OS
    When the flashing sequence completes
    Then the script reboots the device
    And it tells the user the cable can be unplugged
