# /e/OS ships preinstalled on hardware LineageOS does not officially support,
# and supports it for the commercial lifetime of the device. These are the
# platform-side changes that make that hardware work — including the ones
# carried on behalf of partners.
#
# Source: frameworks/base
#   base: mtk_udfps: Prevent HBM not triggering at max user set brightness
#   SystemUI: Reverse MediaTek udfps dimlayer changes
#   UdfpsController: Move HBM enable to dispatchOnUiReady()
#   UdfpsController: Move writeToUdfpsNode to background executor
#   biometrics: Skip unconfigureDisplay if mOnFingerDown
#   Revert "biometrics: Introduce node handling for onPress events"
#   input: Introduce handling for SW_PEN_INSERTED
#   input: Set PEN_INSERTED_STATE_CHANGED intent for org.lineageos.settings
#   base: Add minimal support for Richtap vibrations
#   camera2: Allow enabling high speed batching
#   oemlock: Skip OEM unlock check for Samsung devices
#   base: Enable long press for torch by default
#   base: Allow audio playback capture for every apps
#   AndroidManifest.xml: Specify broadcast for NETWORK_COUNTRYCODE_UPDATED  [Fairphone]
#   SNHooks: Set Build.TYPE to userdebug for dockmanager
#   PhoneStatusBarView: Pad statusbar with Launcher3 dock width
# Source: frameworks/native
#   native: Add dither logic for MediaTek udfps optical devices
#   Add MTK GED KPI support to fix broken Mediatek gpufreq
# Source: frameworks/av
#   libcameraservice: Customize camera stack based on active app  [Fairphone]
# Source: lineage-sdk
#   sdk: Add HW_KILL_SWITCH_ENABLED setting
#   lineage-sdk: Fix missed call LED color settings support
#   LineageSettingsProvider: Use framework value for lock rotation
#   sdk: Avoid TooManyRequestsException SystemUI crash
# Source: packages/modules/Permission
#   PermissionController: Add a role for deviceKeyHandler
# Source: packages/apps/Settings
#   Settings: Add Google's custom sfps resumeEnroll() / Guard Google SFPS extension
#   Settings: Add summary for disabled content-based refresh rate
# Source: vendor/lineage
#   vendor/lineage: Hookup TARGET_USES_MTK_APNS_CONF
#   lineage: Enable large screen support on emulator
#   emulator arm64: update partition size to make it same as x86_64
# Source: external/prebuiltapks RichTap
# Source: build/soong, system/core — see compatibility/play-integrity-compat.feature
# Source: hardware/qcom-caf/thermal (forked on `a16`, not on the `v4.3-a16`
#         reference branch — added after investigating e/os/backlog#4622)
#   thermal-hal: Relax LIGHT and MODERATE skin limits for volcano

@frameworks-base @frameworks-native @lineage-sdk @device @device-specific
Feature: Hardware support for the devices /e/OS ships on

  /e/OS is sold preinstalled — Fairphone, Murena-branded devices, Gigaset — and
  supported for the commercial life of those devices. That means carrying
  platform patches for hardware LineageOS never had to support, including work
  contributed by the device makers themselves.

  Every rule below is conditional. A scenario applies only to the devices whose
  hardware it names, and carrying it to a new Android version is a decision
  taken per item and per device, not an automatic consequence of the port. Read
  each Given as the condition it is: where it does not hold, the scenario does
  not apply.

  Background:
    Given the device runs /e/OS

  Rule: Optical under-display fingerprint sensors on MediaTek platforms

    Several devices /e/OS ships on use an optical under-display sensor behind a
    MediaTek display stack, where the sensor needs the panel driven to high
    brightness at the moment the finger is read.

    Scenario: Reading a fingerprint at maximum brightness
      Given the device has an optical under-display fingerprint sensor
      And the screen brightness is already at its maximum
      When the user touches the sensor
      Then high brightness mode is engaged
      And the fingerprint is read

    Scenario: Reading a fingerprint does not stutter the interface
      Given the device has an optical under-display fingerprint sensor
      When the user touches the sensor
      Then the sensor node is written from a background thread
      And high brightness mode is engaged once the UI is ready to be read
      And the unlock animation is not delayed

    Scenario: The display is not reconfigured while the finger is down
      Given the user's finger is on the sensor
      When the display would otherwise be reconfigured
      Then the reconfiguration is skipped until the finger is lifted

    Scenario: The dim layer is rendered for the sensor, not against it
      Given the device has an optical under-display sensor
      Then the dim layer is dithered as the sensor expects

  Rule: MediaTek platform quirks

    Scenario: GPU frequency scaling
      Given the device uses a MediaTek GPU
      Then the platform reports the performance indicators the vendor driver expects
      And GPU frequency scaling works rather than staying pinned

    Scenario: Carrier settings
      Given the device is built with the MediaTek APN configuration enabled
      Then the MediaTek APN database is installed instead of the common one

  Rule: Partner-contributed changes

    These are carried on behalf of the device maker. They are specified here
    because they change platform behaviour on shipped /e/OS devices.

    Scenario: Camera stack selected per application
      Given the device vendor provides an application-specific camera configuration
      When a camera application starts
      Then the camera stack is configured for that application

    Scenario: Regulatory country code changes are delivered
      Given the vendor stack broadcasts a network country code update
      Then the platform declares the broadcast
      And the components that depend on it are notified

  Rule: Input and peripherals

    Scenario: Stylus silo
      Given the device has a stylus silo
      When the user removes or replaces the stylus
      Then the system reports the insertion state change
      And the device settings application is notified

    Scenario: Docking
      Given the device is docked
      Then the status bar leaves room for the dock
      And the dock manager is able to run

    Scenario: A vendor key handler can hold its role
      Given the device ships a vendor key handler
      Then it can be granted the corresponding role

    Scenario: Rich haptics
      Given the device has a rich haptics engine
      Then the platform can play rich haptic effects
      And the vendor haptics service is shipped

  Rule: Device features surfaced to the user

    Scenario: Hardware privacy switch
      Given the device has a hardware kill switch
      Then its state is exposed as a system setting

    Scenario: Missed call LED
      Given the device has a notification LED
      When a call is missed
      Then the LED colour the user configured is used

    Scenario: Torch on long press
      Given a freshly flashed device
      When the user long-presses the power key
      Then the torch is toggled

    Scenario: Side fingerprint enrolment
      Given the device has a side-mounted fingerprint sensor with the vendor enrolment extension
      When enrolment is interrupted and resumed
      Then it resumes rather than restarting
      And a device without the extension is unaffected

    Scenario: Content-based refresh rate
      Given the device does not support content-based refresh rate
      When the user opens the display settings
      Then the entry explains why it is unavailable rather than being silently disabled

    Scenario: High speed video
      Given the device supports high speed video capture
      Then batching can be enabled for it

  Rule: Platform behaviour /e/OS relaxes for the devices it ships on

    Scenario: OEM unlock check on Samsung devices
      Given the device is a Samsung device whose bootloader does not implement the check
      Then the platform does not block on it

    Scenario: Audio playback capture
      Given an application requests to capture playback audio
      Then the platform does not refuse it on the grounds of the target SDK alone

    Scenario Outline: Skin temperature thresholds on the volcano platform
      Given a device on the volcano thermal platform
      When the "skin" sensor reads a temperature at or above <threshold> milli-degrees
      Then the thermal status becomes <status>
      # Upstream shipped 36500/40000; too low for this platform, which made
      # PowerManager report THERMAL_STATUS_MODERATE on a device that wasn't
      # actually hot — App Lounge then refused to install anything
      # (e/os/backlog#4622). /e/OS raises both thresholds.

      Examples:
        | threshold | status   |
        | 40000     | LIGHT    |
        | 48000     | MODERATE |

  Rule: The emulator is a supported target

    Scenario: Large screen
      Given /e/OS is built for the emulator
      Then large screen support is enabled

    Scenario: Partition size
      Given /e/OS is built for the arm64 emulator
      Then its partition sizes match the x86_64 emulator's
      And the image is usable without resizing it by hand
