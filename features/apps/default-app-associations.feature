# Source: external/prebuiltapks/rro_overlays/FrameworksBaseOverlay/res/values/config.xml
#   config_defaultAutofillService          -> foundation.e.passwords
#   config_enabledCredentialProviderService -> Passwords, then microG
#   config_primaryCredentialProviderService -> Passwords, then microG
#   config_defaultCredentialManagerHybridService -> microG remote service
#   (introduced 2026-04-21 "make password as default autofill provider" and
#    2026-05-08 "make password as default credential manager provider")
# Source: external/prebuiltapks/Glimpse/rro_overlays/GlimpseFrameworksBaseOverlay
#   config_systemGallery -> org.lineageos.glimpse
# Source: external/prebuiltapks/mapsOverlay
#   Magic Earth is shipped under the name "Maps", with /e/OS icons
# Source: vendor/lineage overlay
#   config_defaultQrCodeComponent -> foundation.e.camera QR scanner
#   calendar_component_name -> foundation.e.calendar
#   clock_component_name -> com.android.deskclock
#   vendor_required_apps_managed_device / _managed_user -> BlissLauncher
#   SimpleDeviceConfig: splash_screen_exception_list -> account manager, PWA player
#   camera: use /e/OS camera activity
# Source: vendor/eos overlay
#   config_defaultListenerAccessPackages -> BlissLauncher
#   config_defaultAccessibilityService -> TalkBack FOSS
#   config_wallpaper_picker_action / config_styles_and_wallpaper_picker_action
# Source: external/prebuiltapks — "Drop Murena MDM prebuilt" (2026-02-06)

@vendor-eos @prebuiltapks @vendor-lineage @apps @prebuilt-boundary
Feature: Which application handles what

  Installing the /e/OS applications is not enough: the system has to be told
  which of them holds each role, otherwise Android either falls back to its own
  default or asks the user on every action. This file collects those wiring
  decisions, which are spread across resource overlays and easy to lose sight
  of. The applications themselves are specified in their own repositories.

  Background:
    Given a freshly flashed /e/OS device
    And the user has not changed any default

  Rule: Credentials stay on the device's own password manager

    /e/OS ships a password manager backed by the user's own Nextcloud rather
    than a cloud keychain. It is only useful if the system offers it by default,
    so it holds the autofill and credential roles, with microG behind it for
    applications that ask for a Google passkey specifically.

    Scenario: Filling a login form
      When an application asks for autofill
      Then the /e/OS password manager is offered
      And the user is not asked to pick a provider first

    Scenario: Creating or using a passkey
      When an application requests a credential
      Then the /e/OS password manager is the primary provider
      And microG is offered as a secondary provider

    Scenario: A passkey held on another device
      When an application requests a credential from a nearby device
      Then microG serves the request

    Scenario: The user remains free to change it
      When the user selects another autofill or credential provider
      Then that choice is honoured

  Rule: The /e/OS applications hold the system roles

    Scenario Outline: Roles are pre-assigned
      When the system needs <role>
      Then <application> handles it

      Examples:
        | role                          | application              |
        | the home screen               | BlissLauncher            |
        | the system gallery            | the /e/OS gallery        |
        | a camera intent               | the /e/OS camera         |
        | scanning a QR code            | the /e/OS camera         |
        | a calendar intent             | the /e/OS calendar       |
        | reading notifications         | BlissLauncher            |
        | the screen reader             | the preinstalled TalkBack |

    Scenario: The gallery's storage permission is presented as a system one
      Given the /e/OS gallery holds the system gallery role
      When the user opens its permissions
      Then its media access is shown as a system permission rather than a revocable grant

    Scenario: Dynamic icons are bound to the right applications
      Then the calendar icon is taken from the /e/OS calendar
      And the clock icon is taken from the preinstalled clock

  Rule: The device stays usable when it is managed

    Scenario: A managed device keeps its launcher
      Given the device is provisioned as managed
      Then BlissLauncher is kept as a required application
      And the user is not left without a home screen

    Scenario: A managed user keeps its launcher
      Given a managed user profile is created
      Then BlissLauncher is kept as a required application

  Rule: Presentation details that would otherwise leak the upstream product

    Scenario: The maps application is named for what it does
      Given the preinstalled maps application is a third-party product
      Then it appears to the user as "Maps"
      And it carries the /e/OS icon

    Scenario: Vendor components ship with usable wording
      Given a Qualcomm vendor component such as the broadcast service or the power-off alarm
      Then /e/OS supplies its user-visible strings
      And they are translated in the languages /e/OS ships

    Scenario: Applications that open instantly do not flash a splash screen
      When the account manager or the PWA player is launched
      Then no splash screen is shown

    Scenario: The wallpaper picker is the /e/OS one
      When the user changes the wallpaper or the style
      Then the /e/OS picker opens

  Rule: No device management client is shipped

    /e/OS shipped a Murena MDM prebuilt until it was dropped. A device is
    enrolled by installing the operator's own device owner application.

    Scenario: A consumer device
      Then no device management client is preinstalled

    Scenario: An enrolled device
      Given the device is enrolled by QR code
      Then the device owner application named by the enrolment code is installed
      # See setup/enterprise-provisioning.feature
