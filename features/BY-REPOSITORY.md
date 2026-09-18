# What /e/OS adds or modifies, by repository

Derived from the `# Source:` headers of the `.feature` files — **do not edit**.
Regenerate with `python3 features/tools/gen-by-repository.py` after changing a
specification.

The specifications are organised by feature, because that is how the product is
decided and how the backlog is planned. This index is the other way in: for a
given repository, what /e/OS does there and which specification says so.

49 repositories, generated 2026-09-18.

## Index

- [`.gitlab-ci.yml`](#gitlab-ciyml) — 1 feature(s)
- [`bootable/deprecated-ota`](#bootabledeprecated-ota) — 1 feature(s)
- [`bootable/recovery`](#bootablerecovery) — 1 feature(s)
- [`build/soong`](#buildsoong) — 5 feature(s)
- [`device/lineage/sepolicy`](#devicelineagesepolicy) — 3 feature(s)
- [`external/ih8sn`](#externalih8sn) — 1 feature(s)
- [`external/prebuiltapks`](#externalprebuiltapks) — 7 feature(s)
- [`external/prebuiltapks/*/preinstalled-packages-*.xml`](#externalprebuiltapks*preinstalled-packages-*xml) — 1 feature(s)
- [`external/prebuiltapks/*/privapp-permissions-*.xml`](#externalprebuiltapks*privapp-permissions-*xml) — 1 feature(s)
- [`external/prebuiltapks/Browser/Android.bp`](#externalprebuiltapksbrowserandroidbp) — 1 feature(s)
- [`external/prebuiltapks/Glimpse/rro_overlays/GlimpseFrameworksBaseOverlay`](#externalprebuiltapksglimpserro-overlaysglimpseframeworksbaseoverlay) — 1 feature(s)
- [`external/prebuiltapks/GmsCore/microg.xml`](#externalprebuiltapksgmscoremicrogxml) — 1 feature(s)
- [`external/prebuiltapks/GmsCore/privapp-permissions-com.google.android.gms.xml`](#externalprebuiltapksgmscoreprivapp-permissions-comgoogleandroidgmsxml) — 1 feature(s)
- [`external/prebuiltapks/mapsOverlay`](#externalprebuiltapksmapsoverlay) — 1 feature(s)
- [`external/prebuiltapks/rro_overlays/FrameworksBaseOverlay/res/values/config.xml`](#externalprebuiltapksrro-overlaysframeworksbaseoverlayresvaluesconfigxml) — 1 feature(s)
- [`frameworks/av`](#frameworksav) — 1 feature(s)
- [`frameworks/base`](#frameworksbase) — 16 feature(s)
- [`frameworks/libs/systemui`](#frameworkslibssystemui) — 1 feature(s)
- [`frameworks/native`](#frameworksnative) — 1 feature(s)
- [`frameworks/opt/vcard`](#frameworksoptvcard) — 1 feature(s)
- [`lineage-sdk`](#lineage-sdk) — 1 feature(s)
- [`packages/apps/Backgrounds`](#packagesappsbackgrounds) — 1 feature(s)
- [`packages/apps/Contacts`](#packagesappscontacts) — 3 feature(s)
- [`packages/apps/Dialer`](#packagesappsdialer) — 1 feature(s)
- [`packages/apps/EmergencyInfo`](#packagesappsemergencyinfo) — 1 feature(s)
- [`packages/apps/ImsServiceEntitlement`](#packagesappsimsserviceentitlement) — 1 feature(s)
- [`packages/apps/LineageParts`](#packagesappslineageparts) — 6 feature(s)
- [`packages/apps/ManagedProvisioning`](#packagesappsmanagedprovisioning) — 1 feature(s)
- [`packages/apps/Settings`](#packagesappssettings) — 12 feature(s)
- [`packages/apps/SetupWizard`](#packagesappssetupwizard) — 9 feature(s)
- [`packages/apps/ThemePicker`](#packagesappsthemepicker) — 1 feature(s)
- [`packages/apps/Updater`](#packagesappsupdater) — 2 feature(s)
- [`packages/apps/elib`](#packagesappselib) — 1 feature(s)
- [`packages/apps/{Contacts,Dialer,DocumentsUI,Settings,SettingsIntelligence`](#packagesapps{contacts,dialer,documentsui,settings,settingsintelligence) — 1 feature(s)
- [`packages/inputmethods/LatinIME`](#packagesinputmethodslatinime) — 1 feature(s)
- [`packages/modules/Connectivity`](#packagesmodulesconnectivity) — 1 feature(s)
- [`packages/modules/DnsResolver`](#packagesmodulesdnsresolver) — 1 feature(s)
- [`packages/modules/Permission`](#packagesmodulespermission) — 2 feature(s)
- [`packages/overlays/Lineage`](#packagesoverlayslineage) — 1 feature(s)
- [`packages/services/Telephony`](#packagesservicestelephony) — 1 feature(s)
- [`system/core`](#systemcore) — 1 feature(s)
- [`the`](#the) — 1 feature(s)
- [`vendor/apn`](#vendorapn) — 1 feature(s)
- [`vendor/eos`](#vendoreos) — 16 feature(s)
- [`vendor/eos/config/common.mk`](#vendoreosconfigcommonmk) — 1 feature(s)
- [`vendor/eos/flash`](#vendoreosflash) — 1 feature(s)
- [`vendor/lineage`](#vendorlineage) — 11 feature(s)
- [`vendor/lineage/config/version.mk`](#vendorlineageconfigversionmk) — 1 feature(s)
- [`~40`](#~40) — 1 feature(s)

## `.gitlab-ci.yml`

**Keeping the fork current with LineageOS** — [`process/fork-maintenance.feature`](process/fork-maintenance.feature)

- in 83 of the forked projects, including
- the auto-merge-main and import-updates-from-upstream templates from


## `bootable/deprecated-ota`

**Recovery** — [`device/recovery.feature`](device/recovery.feature)

- applypatch: Always update recovery image
- (the property gate persist.vendor.recovery_update is removed)


## `bootable/recovery`

**Recovery** — [`device/recovery.feature`](device/recovery.feature)

- recovery: ui: rebrand logo and initial /e/ layout
- Remove ip address from recovery ui
- recovery: Update FastbootD and recovery images
- Revert "recovery: Ask to reboot before installing anything after A/B update"


## `build/soong`

**The device presents itself as /e/OS** — [`branding/identity.feature`](branding/identity.feature)

- Change build description in Settings > About Phone

**Applications that check device integrity keep working** — [`compatibility/play-integrity-compat.feature`](compatibility/play-integrity-compat.feature)

- Spoof build variant by removing "debug" in Settings > About Phone
- Change build description in Settings > About Phone

**Hardware support for the devices /e/OS ships on** — [`device/hardware-support.feature`](device/hardware-support.feature)

- system/core — see compatibility/play-integrity-compat.feature

**LineageOS-specific surfaces are replaced by /e/OS ones** — [`system/lineage-features-removed.feature`](system/lineage-features-removed.feature)

- soong: Use our keys for otacerts if it exists

**Release types** — [`updates/release-types.feature`](updates/release-types.feature)

- soong: Use our keys for otacerts if it exists (user-keys/releasekey)


## `device/lineage/sepolicy`

**Preinstalled applications are usable without a permission gauntlet** — [`apps/default-permissions.feature`](apps/default-permissions.feature)

- lineage: Allow platform apps to read custom props
- sepolicy: All platform app to create sockets
- sepolicy: allow platform_app access app_data_file
- sepolicy: allow platform_app rs_exec / named pipes
- allow netd platform_app:unix_stream_socket connectto (the tracker blocker)
- allow platform_app app_data_file:file execute

**System-wide tracker blocking at DNS resolution** — [`privacy/tracker-blocking-dns.feature`](privacy/tracker-blocking-dns.feature)

- sepolicy: Add rules for tracker blocker

**/e/OS system updates** — [`updates/ota-updater.feature`](updates/ota-updater.feature)

- sepolicy: Updater: Add support for systemUpdatermanager


## `external/ih8sn`

**Applications that check device integrity keep working** — [`compatibility/play-integrity-compat.feature`](compatibility/play-integrity-compat.feature)

- vendor/eos config/ih8sn/*


## `external/prebuiltapks`

**Which application handles what** — [`apps/default-app-associations.feature`](apps/default-app-associations.feature)

- — "Drop Murena MDM prebuilt" (2026-02-06)

**Maintenance of the prebuilt applications** — [`apps/prebuilt-maintenance.feature`](apps/prebuilt-maintenance.feature)

- config/common.mk, config/telephony.mk — which prebuilt is shipped, and for
- which platform SDK level; per-SDK variants (…Legacy, …_A12/_A13/_A14, …Slim)
- Git LFS repository — the APKs themselves are LFS pointers
- promotion from the application repositories into external/prebuiltapks.

**The /e/OS application set** — [`apps/preinstalled-applications.feature`](apps/preinstalled-applications.feature)

- config/common.mk, config/telephony.mk

**Android Auto can be installed by the user** — [`compatibility/android-auto.feature`](compatibility/android-auto.feature)

- AndroidAutoStub
- can side-load the APK; it installs and then fails, because the privileged
- permissions it needs are not grantable to a user-installed application.
- Cost: a feature a large share of drivers consider non-negotiable.
- the privileged permission allowlist, and let the user install the real,
- Google-signed APK over it. This is what /e/OS does. It requires relaxing
- the "an update must be signed by the same key as what it replaces" rule
- for exactly this case.
- stub. Rejected: that is a general privilege-escalation primitive.

**Hardware support for the devices /e/OS ships on** — [`device/hardware-support.feature`](device/hardware-support.feature)

**Restoring a backup during first-time setup** — [`setup/backup-restore.feature`](setup/backup-restore.feature)

**Keyboard with on-device speech to text** — [`system/keyboard.feature`](system/keyboard.feature)

- MurenaVoiceToTextOffline


## `external/prebuiltapks/*/preinstalled-packages-*.xml`

**Preinstalled applications are usable without a permission gauntlet** — [`apps/default-permissions.feature`](apps/default-permissions.feature)

- initial-package-stopped-states-*.xml
- which user types receive which application


## `external/prebuiltapks/*/privapp-permissions-*.xml`

**Preinstalled applications are usable without a permission gauntlet** — [`apps/default-permissions.feature`](apps/default-permissions.feature)

- permissions_*.xml,
- allowlist_*.xml, whitelist_*.xml (19 files)
- privileged permission allowlists, power-save and hidden-API allowances


## `external/prebuiltapks/Browser/Android.bp`

**The browser and the WebView are updated independently of the system** — [`apps/browser-and-webview.feature`](apps/browser-and-webview.feature)

- two independent android_app_import modules — Browser (ChromePublic.apk) and
- BrowserWebView (SystemWebView.apk) — per architecture, signed with the
- platform certificate; BrowserWebView overrides the AOSP "webview" module,
- Browser overrides Jelly, Browser2 and QuickSearchBox


## `external/prebuiltapks/Glimpse/rro_overlays/GlimpseFrameworksBaseOverlay`

**Which application handles what** — [`apps/default-app-associations.feature`](apps/default-app-associations.feature)

- config_systemGallery -> org.lineageos.glimpse


## `external/prebuiltapks/GmsCore/microg.xml`

**What microG does out of the box** — [`compatibility/microg-configuration.feature`](compatibility/microg-configuration.feature)

- the default microG configuration /e/OS ships, applied before first boot


## `external/prebuiltapks/GmsCore/privapp-permissions-com.google.android.gms.xml`

**What microG does out of the box** — [`compatibility/microg-configuration.feature`](compatibility/microg-configuration.feature)


## `external/prebuiltapks/mapsOverlay`

**Which application handles what** — [`apps/default-app-associations.feature`](apps/default-app-associations.feature)

- Magic Earth is shipped under the name "Maps", with /e/OS icons


## `external/prebuiltapks/rro_overlays/FrameworksBaseOverlay/res/values/config.xml`

**Which application handles what** — [`apps/default-app-associations.feature`](apps/default-app-associations.feature)

- config_defaultAutofillService          -> foundation.e.passwords
- config_enabledCredentialProviderService -> Passwords, then microG
- config_primaryCredentialProviderService -> Passwords, then microG
- config_defaultCredentialManagerHybridService -> microG remote service
- (introduced 2026-04-21 "make password as default autofill provider" and
- 2026-05-08 "make password as default credential manager provider")


## `frameworks/av`

**Hardware support for the devices /e/OS ships on** — [`device/hardware-support.feature`](device/hardware-support.feature)

- libcameraservice: Customize camera stack based on active app  [Fairphone]


## `frameworks/base`

**One visual identity across the system applications** — [`apps/application-icons-and-theme.feature`](apps/application-icons-and-theme.feature)

- system_primary_light/dark and accent_material_light/dark -> e_accent_*

**Preinstalled applications are usable without a permission gauntlet** — [`apps/default-permissions.feature`](apps/default-permissions.feature)

- base: Grant internet permission for new/updated system apps
- base: Grant /e/ Drive storage permission

**The device presents itself as /e/OS** — [`branding/identity.feature`](branding/identity.feature)

- base: sounds: Change camera click/stop/record sounds

**Android Auto can be installed by the user** — [`compatibility/android-auto.feature`](compatibility/android-auto.feature)

- Allow to install Google signed Android Auto APK
- InstallPackageHelper#isAndroidAutoApk, PackageManagerServiceUtils#isAndroidAutoApk
- Android Auto: Support Android Auto as user app 1/2
- PermissionManagerServiceImpl: PACKAGE_ANDROID_AUTO,
- SIGNATURE_ANDROID_AUTO (pinned SHA-256 of Google's signing certificate),
- PERMISSIONS_ANDROID_AUTO (13 privileged permissions)

**Android Auto can be installed by the user** — [`compatibility/android-auto.feature`](compatibility/android-auto.feature)

- core/res config.xml
- config_systemAutomotiveProjection -> gearhead + the same certificate digest
- config_companionDevicePackages / config_companionDeviceCerts -> gearhead

**App links are verified right after installation** — [`compatibility/app-links-verification.feature`](compatibility/app-links-verification.feature)

- Make 3rd party app links verification work
- (packages/StatementService — removal of the network-blocking guard)

**App Lounge behaves as the device's application store** — [`compatibility/app-lounge-as-installer.feature`](compatibility/app-lounge-as-installer.feature)

- Always return initiating package as the installer package (InstallSourceInfo)
- pm: Escape user permission for app lounge (PackageInstallerSession)

**microG support out of the box** — [`compatibility/microg-signature-spoofing.feature`](compatibility/microg-signature-spoofing.feature)

- Allow signature spoofing for system apps (ComputerEngine)

**Applications that check device integrity keep working** — [`compatibility/play-integrity-compat.feature`](compatibility/play-integrity-compat.feature)

- keystore: Block key attestation for SafetyNet (SafetyNetHooks)
- Spoof MODEL, DEVICE, PRODUCT & FINGERPRINT
- SNHooks: Set Build.TYPE to userdebug for dockmanager

**Network defaults** — [`connectivity/network-defaults.feature`](connectivity/network-defaults.feature)

- AndroidManifest.xml: Specify broadcast for NETWORK_COUNTRYCODE_UPDATED

**Hardware support for the devices /e/OS ships on** — [`device/hardware-support.feature`](device/hardware-support.feature)

- base: mtk_udfps: Prevent HBM not triggering at max user set brightness
- SystemUI: Reverse MediaTek udfps dimlayer changes
- UdfpsController: Move HBM enable to dispatchOnUiReady()
- UdfpsController: Move writeToUdfpsNode to background executor
- biometrics: Skip unconfigureDisplay if mOnFingerDown
- Revert "biometrics: Introduce node handling for onPress events"
- input: Introduce handling for SW_PEN_INSERTED
- input: Set PEN_INSERTED_STATE_CHANGED intent for org.lineageos.settings
- base: Add minimal support for Richtap vibrations
- camera2: Allow enabling high speed batching
- oemlock: Skip OEM unlock check for Samsung devices
- base: Enable long press for torch by default
- base: Allow audio playback capture for every apps
- AndroidManifest.xml: Specify broadcast for NETWORK_COUNTRYCODE_UPDATED  [Fairphone]
- SNHooks: Set Build.TYPE to userdebug for dockmanager
- PhoneStatusBarView: Pad statusbar with Launcher3 dock width

**The /e/ account is the device's primary account** — [`identity/e-account.feature`](identity/e-account.feature)

- base: Grant /e/ Drive storage permission

**Per-application fake location** — [`privacy/fake-location.feature`](privacy/fake-location.feature)

- feat:2400: fake location from AdvancedPrivacy ContentProvider.
- fix:8489: Quick return fakelocation. Fix calling package and uid doesn't match
- to resolve fakeLocationProvider
- services/core/java/com/android/server/location/FakeLocationResolver.java

**Hiding microG from selected applications** — [`privacy/hide-microg-from-apps.feature`](privacy/hide-microg-from-apps.feature)

- feat: Introduce Hide From Microg feature
- Settings.System.HIDE_MICROG_PACKAGES_FOR_PACKAGE
- AppsFilterBase / AppsFilterImpl / PackageManagerService

**Parental control** — [`system/parental-control.feature`](system/parental-control.feature)

- base: allow parental control to be activated with accounts (DevicePolicyManagerService)

**System UI follows the /e/OS design** — [`system/system-ui.feature`](system/system-ui.feature)

- SystemUI: Theme according to our palette / Theme system components according to our palette
- SettingsLib: Theme according to our palette / replace compose switch with our own
- Add e colors and e switch
- Remove wallet tile
- core/res config_keyguardQuickAffordanceDefault: bottom_end wallet -> none
- Remove partial screenshot from recents
- SystemUI: change intent for viewing screenshots
- keyguard: Keep SIM card name visible during PIN entry
- fix light mode 3 button navigation
- SystemUI: apply light/dark theme to shade header elements
- SystemUI: Follow light/dark theme in quick settings / power menu / SplitShade header
- SystemUI: Add dual-tone light and dark themes for QS
- SystemUI: Re-evaluate system theme on UI mode change / Recreate overlays anyway
- Don't create dynamic overlay
- PhoneStatusBarView: Pad statusbar with Launcher3 dock width
- fix: long pressing notifications crashing SystemUI
- fix color of emphasized notification / Update legacy autofill bottomsheet


## `frameworks/libs/systemui`

**Notification badges carry a count** — [`system/notification-badges.feature`](system/notification-badges.feature)

- — iconloaderlib DotRenderer, IconProvider
- feat(dots): notification count support for launcher3 app badges
- feat: convert badge to round rect when count > 99
- DotRenderer: Add shadow to notification dots
- fix: Properly handle tablet notification icons / Tune further for tablet
- fix: Revert badge size and position to pre-tablet
- feat(icons): Add month icon support for calendar
- fix: Return intended notification count / Render notificationBadges as intended
- (the a16 badge-geometry rework — density-independent ratio, centring on the
- first digit — was reverted; this file describes the tree as it stands)


## `frameworks/native`

**Hardware support for the devices /e/OS ships on** — [`device/hardware-support.feature`](device/hardware-support.feature)

- native: Add dither logic for MediaTek udfps optical devices
- Add MTK GED KPI support to fix broken Mediatek gpufreq


## `frameworks/opt/vcard`

**Telephony and contacts behaviour** — [`system/telephony-and-messaging.feature`](system/telephony-and-messaging.feature)

- fixed: exporting custom field for IM


## `lineage-sdk`

**Hardware support for the devices /e/OS ships on** — [`device/hardware-support.feature`](device/hardware-support.feature)

- sdk: Add HW_KILL_SWITCH_ENABLED setting
- lineage-sdk: Fix missed call LED color settings support
- LineageSettingsProvider: Use framework value for lock rotation
- sdk: Avoid TooManyRequestsException SystemUI crash


## `packages/apps/Backgrounds`

**The device presents itself as /e/OS** — [`branding/identity.feature`](branding/identity.feature)

- Add phone wallpapers / Add tablet wallpapers / Convert wallpapers to webp


## `packages/apps/Contacts`

**The /e/ account is the device's primary account** — [`identity/e-account.feature`](identity/e-account.feature)

- 709-s-Open_accountManager_onClick_add_account
- Contacts: Sort /e/ account with first priority and allow user to modify
- primary account for profile
- Issue 1776: Default to phone-only if no account
- Issue 1756: Account selector ui fix
- Issue 1317: Fix address books appearing repeatedly

**No Google server is contacted by default** — [`privacy/degoogled-defaults.feature`](privacy/degoogled-defaults.feature)

- Contacts: Drop google maps web intent

**Telephony and contacts behaviour** — [`system/telephony-and-messaging.feature`](system/telephony-and-messaging.feature)

- Contacts: Support changing vCard export version
- Contacts: show labels for contacts


## `packages/apps/Dialer`

**Telephony and contacts behaviour** — [`system/telephony-and-messaging.feature`](system/telephony-and-messaging.feature)

- dialer: callrecord: Enable call recording by default with VOICE_CALL as source
- 3736-R-Hide_voice_search_button


## `packages/apps/EmergencyInfo`

**Telephony and contacts behaviour** — [`system/telephony-and-messaging.feature`](system/telephony-and-messaging.feature)

- EmergencyInfo: Ask to unlock to view emergency contact


## `packages/apps/ImsServiceEntitlement`

**No Google server is contacted by default** — [`privacy/degoogled-defaults.feature`](privacy/degoogled-defaults.feature)

- Delay FCM registration until it's actually required


## `packages/apps/LineageParts`

**microG support out of the box** — [`compatibility/microg-signature-spoofing.feature`](compatibility/microg-signature-spoofing.feature)

- LineageParts: Add microg to system settings
- feat: rename "microG" into "App compatibility"

**No statistics collection, opt-in crash reporting only** — [`privacy/telemetry.feature`](privacy/telemetry.feature)

- LineageParts: Remove LineageOS stats collection support completely
- LineageParts: Set sentry user id on boot

**LineageOS-specific surfaces are replaced by /e/OS ones** — [`system/lineage-features-removed.feature`](system/lineage-features-removed.feature)

- LineageParts: Remove LineageOS stats collection support completely
- LineageParts: Add /e/ contributors
- LineageParts: Change references to /e/ OS in Trust ASB dialog
- LineageParts: Add openkeychain
- feat: rename "microG" into "App compatibility"

**Parental control** — [`system/parental-control.feature`](system/parental-control.feature)

- Parts: Disable advance reboot for parental control

**System UI follows the /e/OS design** — [`system/system-ui.feature`](system/system-ui.feature)

- Remove split screen option from recents long press actions

**Monthly security patch level** — [`updates/security-patches.feature`](updates/security-patches.feature)

- LineageParts: Change references to /e/ OS in Trust ASB dialog


## `packages/apps/ManagedProvisioning`

**Enrolling a device by QR code during setup** — [`setup/enterprise-provisioning.feature`](setup/enterprise-provisioning.feature)


## `packages/apps/Settings`

**Network defaults** — [`connectivity/network-defaults.feature`](connectivity/network-defaults.feature)

- Replace cloudflare with quad9 as dns provider
- Settings: Change ping to quad9 dns

**Hardware support for the devices /e/OS ships on** — [`device/hardware-support.feature`](device/hardware-support.feature)

- Settings: Add Google's custom sfps resumeEnroll() / Guard Google SFPS extension
- Settings: Add summary for disabled content-based refresh rate

**The /e/ account is the device's primary account** — [`identity/e-account.feature`](identity/e-account.feature)

- Settings: mark eDrive as safe to be opened by accountManager
- 697-s-Recalculate_accountType_sorting
- Settings: top_level_settings: Move accounts entry to top
- Improve wordings for automatic sync
- Update remove account dialog message to make it more clear
- Settings: Notify users all their accounts will be removed and not just google

**No Google server is contacted by default** — [`privacy/degoogled-defaults.feature`](privacy/degoogled-defaults.feature)

- Settings: Remove google animations and links

**No Google server is contacted by default** — [`privacy/degoogled-defaults.feature`](privacy/degoogled-defaults.feature)

- packages/modules/Connectivity
- Replace cloudfare/google dns with quad9

**No statistics collection, opt-in crash reporting only** — [`privacy/telemetry.feature`](privacy/telemetry.feature)

- Write telemetry system settings (EnableTelemetryPreferenceController)
- Settings: add preference for sentry user id (SentryDetailPreferenceController)
- Add a dedicated section in developer options for /e/OS related settings

**Advanced Privacy is part of the settings** — [`system/advanced-privacy-entry.feature`](system/advanced-privacy-entry.feature)

- Settings: Integrate Advanced Privacy into settings
- (AdvancedPrivacyDashboardFragment, advanced_privacy_dashboard_settings.xml)

**Find My Device** — [`system/find-my-device.feature`](system/find-my-device.feature)

- Settings: add find my device entry in settings
- (FindMyDeviceDashboardFragment, TopLevelFindMyDeviceEntryPreferenceController)
- Settings: Remove find my device from security settings summary

**LineageOS-specific surfaces are replaced by /e/OS ones** — [`system/lineage-features-removed.feature`](system/lineage-features-removed.feature)

- Settings: Change updater summary for /e/OS version

**Parental control** — [`system/parental-control.feature`](system/parental-control.feature)

- Settings: add parental control changes (ParentalControlDashboardFragment,
- top_level_settings, admin-disabled wording)

**The Settings home page is organised around /e/OS** — [`system/settings-organisation.feature`](system/settings-organisation.feature)

- Move backup entry to top level settings
- Settings: top_level_settings: Move accounts entry to top
- Settings: Move updater to top of settings main page
- Settings: Integrate Advanced Privacy into settings
- Settings: add parental control changes / find my device entry
- Remove smart cleanup card
- Settings: Remove security settings placeholder
- Allow to remove tint for homepage icons
- Change default highlight key which makes top entries visible in tablet
- fix security screen in setup wizard being cut in portrait mode of tablet
- Settings: Add /e/ legal
- Settings: res: Set proper title for system version
- config_use_legacy_suggestion=false, contextual card feedback -> contact@e.email

**/e/OS system updates** — [`updates/ota-updater.feature`](updates/ota-updater.feature)

- Settings: Move updater to top of settings main page
- Settings: Switch to select prod or staging OTA server
- Settings: Change updater summary for /e/OS version


## `packages/apps/SetupWizard`

**The device presents itself as /e/OS** — [`branding/identity.feature`](branding/identity.feature)

- packages/apps/Updater, …
- Replace lineage strings and logo with /e/

**Recovery** — [`device/recovery.feature`](device/recovery.feature)

- SetupWizard: Skip recovery update option

**No statistics collection, opt-in crash reporting only** — [`privacy/telemetry.feature`](privacy/telemetry.feature)

- SetupWizard: Disable LineageOS metrics

**Restoring a backup during first-time setup** — [`setup/backup-restore.feature`](setup/backup-restore.feature)

- Add restore page for backup app
- Launch restore when EAccount is available
- feat:4037: set e account setting early, before restore eBackup step
- Skip theme, FMD and navigation settings if restore finished
- Update restore activity action
- fix restore intro restore button binding
- Move account check to helper class

**OEM unlocking is turned off once the device is secured** — [`setup/bootloader-state.feature`](setup/bootloader-state.feature)

- SetupWizard: Turn off OEM unlocking during initial setup if bootloader is locked
- SetupWizard: Toggle oem unlocking toggle for Pixel 5 only

**Enrolling a device by QR code during setup** — [`setup/enterprise-provisioning.feature`](setup/enterprise-provisioning.feature)

- Implemented MDM provisioning by QR code
- Added signature-based checksum support.

**First-time setup wizard** — [`setup/setup-wizard-flow.feature`](setup/setup-wizard-flow.feature)

- Replace lineage strings and logo with /e/
- SetupWizard: Add /e/ account manager page
- Move account setup after date & time
- Hide login/create if logged in
- Theme app according to our palette
- Add parental control page
- Adding the Find my device screen to FTW
- SetupWizard: Enable wifi location
- SetupWizard: Skip recovery update option
- Set BlissLauncher as default when moments is installed
- Fix welcome layout root id in sw600dp and tv
- Port translations from A14

**Find My Device** — [`system/find-my-device.feature`](system/find-my-device.feature)

- Adding the Find my device screen to FTW

**Parental control** — [`system/parental-control.feature`](system/parental-control.feature)

- Add parental control page


## `packages/apps/ThemePicker`

**LineageOS-specific surfaces are replaced by /e/OS ones** — [`system/lineage-features-removed.feature`](system/lineage-features-removed.feature)

- ThemePicker: Remove wallpaper color selection


## `packages/apps/Updater`

**/e/OS system updates** — [`updates/ota-updater.feature`](updates/ota-updater.feature)

- Updater: Rebrand to /e/ OS
- Updater: Update the OTA url / Change default user-agent / Get /e/ release notes
- Updater: Allow OTA updates with different version number
- Updater: Check updates daily
- Updater: Enable auto deletion of updates by default
- Updater: Update A/B devices on one go
- Updater: Check for free space on install
- Updater: Add network ConnectionStateMonitor
- Updater: Add permanent reboot notification & delete update
- Updater: add option to show all updates
- Updater: /e/ changes for local update
- Updater: Generate anon id for ota requests
- Updater: Improve UX for users taking version upgrades
- Updater: Add support for SystemUpdateManager status
- Use custom tab intent for changelog
- Update: add json validator

**Release types** — [`updates/release-types.feature`](updates/release-types.feature)

- Utils#getServerURL substitutes {type}; Utils#canInstall rejects an update
- whose type differs from ro.lineage.releasetype (both upstream mechanisms,
- driven by the /e/OS vocabulary)


## `packages/apps/elib`

**One visual identity across the system applications** — [`apps/application-icons-and-theme.feature`](apps/application-icons-and-theme.feature)

- lib/src/main/res/values/colors.xml: e_accent_light #0086FF, e_accent_dark #5DB2FF


## `packages/apps/{Contacts,Dialer,DocumentsUI,Settings,SettingsIntelligence`

**One visual identity across the system applications** — [`apps/application-icons-and-theme.feature`](apps/application-icons-and-theme.feature)

- FMRadio,Gallery2,ThemePicker,WallpaperPicker2,Updater,LatinIME,LineageParts,
- Permission}
- Change app icon to our custom icon / Update app icon according to new design
- Theme app according to our palette


## `packages/inputmethods/LatinIME`

**Keyboard with on-device speech to text** — [`system/keyboard.feature`](system/keyboard.feature)

- LatinIME: Add icon on the keyboard to access STT feature
- feat(stt): target the offline STT keyboard and drop premium gating
- Rename the floating button to the STT button
- Show mic on the strip when suggestions are disabled
- Enable emoji key by default for old and new users
- 3736-Q-Set_voice_input_key_preference_default_false
- LatinIME: Reload theme on configuration change / Retheme app according to new base
- LatinIME: add elib
- LatinIME: Add OLED theme, clipboard paste key, number row tweaks,
- slide-to-delete (upstream contributions carried by /e/OS)


## `packages/modules/Connectivity`

**Network defaults** — [`connectivity/network-defaults.feature`](connectivity/network-defaults.feature)

- Replace google dns with quadnine dns


## `packages/modules/DnsResolver`

**System-wide tracker blocking at DNS resolution** — [`privacy/tracker-blocking-dns.feature`](privacy/tracker-blocking-dns.feature)

- dnsresolver: use dns blocker app to filter trackers
- dnsresolver: Adapt for Unix socket
- DnsResolver: Change socket name
- shouldBlockRequest: Don't block if socket connect fails


## `packages/modules/Permission`

**Android Auto can be installed by the user** — [`compatibility/android-auto.feature`](compatibility/android-auto.feature)

- Android Auto: Support Android Auto as user app 2/2

**Hardware support for the devices /e/OS ships on** — [`device/hardware-support.feature`](device/hardware-support.feature)

- PermissionController: Add a role for deviceKeyHandler


## `packages/overlays/Lineage`

**One visual identity across the system applications** — [`apps/application-icons-and-theme.feature`](apps/application-icons-and-theme.feature)

- overlays: Add circle icon overlay


## `packages/services/Telephony`

**No Google server is contacted by default** — [`privacy/degoogled-defaults.feature`](privacy/degoogled-defaults.feature)

- Telephony: Use quad9.net for http


## `system/core`

**Applications that check device integrity keep working** — [`compatibility/play-integrity-compat.feature`](compatibility/play-integrity-compat.feature)

- Spoof yellow verified boot state to green


## `the`

**Keeping the fork current with LineageOS** — [`process/fork-maintenance.feature`](process/fork-maintenance.feature)

- manifest repository itself — snippets/eos.xml, default.xml


## `vendor/apn`

**Carrier APN database** — [`connectivity/apn-database.feature`](connectivity/apn-database.feature)

- Move our apn config from vendor_lineage
- ~15 carrier-specific corrections (FR, SE, NO, IT, NL, AT, PT, CA, AU, IN, …)
- vendor/apn: use apns-conf-mtk.xml if uses_mtk_apns_conf soong config var is set
- apns-conf.xsd: make type field optional for now


## `vendor/eos`

**One visual identity across the system applications** — [`apps/application-icons-and-theme.feature`](apps/application-icons-and-theme.feature)

- overlay/no-rro/external/setupdesign

**Which application handles what** — [`apps/default-app-associations.feature`](apps/default-app-associations.feature)

- config_defaultListenerAccessPackages -> BlissLauncher
- config_defaultAccessibilityService -> TalkBack FOSS
- config_wallpaper_picker_action / config_styles_and_wallpaper_picker_action

**Preinstalled applications are usable without a permission gauntlet** — [`apps/default-permissions.feature`](apps/default-permissions.feature)

- config/permissions/eos-allowlist.xml

**Preinstalled applications are usable without a permission gauntlet** — [`apps/default-permissions.feature`](apps/default-permissions.feature)

- config/permissions/eos-permissions.xml

**The /e/OS application set** — [`apps/preinstalled-applications.feature`](apps/preinstalled-applications.feature)

- config/common.mk, config/common_mobile.mk

**Google proprietary blobs are stripped from device builds** — [`apps/proprietary-app-removal.feature`](apps/proprietary-app-removal.feature)

- remove/Android.mk (RemoveProprietaryApps)

**The device presents itself as /e/OS** — [`branding/identity.feature`](branding/identity.feature)

- config/common_mobile.mk, config/telephony.mk
- default notification, alarm and ringtone sounds

**App Lounge behaves as the device's application store** — [`compatibility/app-lounge-as-installer.feature`](compatibility/app-lounge-as-installer.feature)

- config/permissions/eos-allowlist.xml (app-link foundation.e.apps)

**microG support out of the box** — [`compatibility/microg-signature-spoofing.feature`](compatibility/microg-signature-spoofing.feature)

- config/permissions/eos-permissions.xml
- com.google.android.gms: FAKE_PACKAGE_SIGNATURE, INSTALL_LOCATION_PROVIDER,
- CHANGE_DEVICE_IDLE_TEMP_WHITELIST
- com.android.vending: FAKE_PACKAGE_SIGNATURE

**Network defaults** — [`connectivity/network-defaults.feature`](connectivity/network-defaults.feature)

- overlay (SettingsLib wifi_dns hints, wifi scan throttle exceptions)

**The /e/ account is the device's primary account** — [`identity/e-account.feature`](identity/e-account.feature)

- config/permissions (foundation.e.accountmanager, foundation.e.drive)

**No Google server is contacted by default** — [`privacy/degoogled-defaults.feature`](privacy/degoogled-defaults.feature)

- overlay/common/frameworks/base/core/res (config_ntpServers,
- config_default_dns_server, config_enableNetworkLocationOverlay,
- config_enableFusedLocationOverlay)

**Find My Device** — [`system/find-my-device.feature`](system/find-my-device.feature)

- config/permissions (foundation.e.findmydevice)

**Keyboard with on-device speech to text** — [`system/keyboard.feature`](system/keyboard.feature)

- config/permissions (foundation.e.stt)

**Parental control** — [`system/parental-control.feature`](system/parental-control.feature)

- config/permissions (foundation.e.parentalcontrol)

**System UI follows the /e/OS design** — [`system/system-ui.feature`](system/system-ui.feature)

- overlay (flag_monet=false -> Material You / Monet off, launcher_overlayable_package,
- config_defaultListenerAccessPackages, config_longPressOnAppSwitchBehavior)


## `vendor/eos/config/common.mk`

**Release types** — [`updates/release-types.feature`](updates/release-types.feature)

- INCLUDE_IH8SN gated on RELEASE_TYPE and on TARGET_BUILD_VARIANT


## `vendor/eos/flash`

**Self-contained flashing package for manual installation** — [`device/flashing-package.feature`](device/flashing-package.feature)

- Android.mk           — builds IMG-e-<version>.zip, hooked onto `bacon`
- factory.common       — the shared flashing logic
- <device>/config.mk   — which images go into the package, per device
- <device>/flash_<device>_factory.sh — per-device parameters
- fastboot/bin-linux-x86, bin-darwin, bin-msys — bundled fastboot binaries
- axolotl, emerald, mimir, otter, panther, redfin, rigby, sapphire, shiba,
- tetris, two, zirconia


## `vendor/lineage`

**Which application handles what** — [`apps/default-app-associations.feature`](apps/default-app-associations.feature)

- config_defaultQrCodeComponent -> foundation.e.camera QR scanner
- calendar_component_name -> foundation.e.calendar
- clock_component_name -> com.android.deskclock
- vendor_required_apps_managed_device / _managed_user -> BlissLauncher
- SimpleDeviceConfig: splash_screen_exception_list -> account manager, PWA player
- camera: use /e/OS camera activity

**The /e/OS application set** — [`apps/preinstalled-applications.feature`](apps/preinstalled-applications.feature)

- camera: use /e/OS camera activity
- vendor: Exclude AudioFX by default
- overlay: Adjust package name for our calendar
- overlay: Dont show splash for AccountManager and PWA player

**The device presents itself as /e/OS** — [`branding/identity.feature`](branding/identity.feature)

- vendor: Set /e/ package name & version on builds
- version: Bump to /e/OS vX.Y
- Add our own bootanimation
- Update default wallpaper / Update default wallpaper in overlay
- Add tablet package for wallpapers / overlay: Update wallpapers for tablet product
- vendor/lineage: Change emulator name
- vendor: config: Include configuration for eos

**Carrier APN database** — [`connectivity/apn-database.feature`](connectivity/apn-database.feature)

- vendor/lineage: Hookup TARGET_USES_MTK_APNS_CONF

**Hardware support for the devices /e/OS ships on** — [`device/hardware-support.feature`](device/hardware-support.feature)

- vendor/lineage: Hookup TARGET_USES_MTK_APNS_CONF
- lineage: Enable large screen support on emulator
- emulator arm64: update partition size to make it same as x86_64

**No Google server is contacted by default** — [`privacy/degoogled-defaults.feature`](privacy/degoogled-defaults.feature)

- vendor: overlay: Update default captive portal URLs
- Add ichnaea & nominatim backends into indicators exempted package list

**LineageOS-specific surfaces are replaced by /e/OS ones** — [`system/lineage-features-removed.feature`](system/lineage-features-removed.feature)

- lineage: Drop lineage otacert
- vendor: lineage: remove nfc and fingerprint help url
- Do not ship addon.d/50-lineage.sh anymore
- vendor/lineage: Drop partner gms makefiles
- vendor: Exclude AudioFX by default

**The Settings home page is organised around /e/OS** — [`system/settings-organisation.feature`](system/settings-organisation.feature)

- Revert settings card layout

**System UI follows the /e/OS design** — [`system/system-ui.feature`](system/system-ui.feature)

- Disable private space

**Telephony and contacts behaviour** — [`system/telephony-and-messaging.feature`](system/telephony-and-messaging.feature)

- vendor/lineage: telephony: Default enable mobile data OOTB

**Monthly security patch level** — [`updates/security-patches.feature`](updates/security-patches.feature)

- Bump security string to <month> (monthly, ahead of LineageOS)
- version: Bump to /e/OS vX.Y


## `vendor/lineage/config/version.mk`

**Release types** — [`updates/release-types.feature`](updates/release-types.feature)

- LineageOS accepts   RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL
- /e/OS accepts       test community official partner
- anything else falls back to UNOFFICIAL
- LINEAGE_VERSION_SUFFIX gains CI_PIPELINE_ID; ANDROID_LETTER, maintenance
- and prerelease components are /e/OS additions
- published as ro.lineage.releasetype / ro.lineage.version


## `~40`

**Monthly security patch level** — [`updates/security-patches.feature`](updates/security-patches.feature)

- forked projects carrying Android Security Bulletin backports
- (frameworks/base, frameworks/av, packages/modules/Bluetooth,
- packages/modules/Nfc, external/libpng, external/freetype, …)
