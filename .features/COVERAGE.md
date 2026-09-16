# Coverage of the /e/OS forks

Reference: the `v4.3-a16` manifest. The `a16` development manifest forks fewer
projects — the extra forks on `v4.3-a16` exist to carry the monthly security
patch — and adds `hardware/qcom-caf/thermal`, which is therefore not covered.

Method: every `<project>` of `snippets/eos.xml` was diffed against its LineageOS
counterpart (`lineage-23` checkout, same path). Since /e/OS merges LineageOS
regularly, the LineageOS HEAD is an ancestor of the /e/OS HEAD for most
projects, so `git log <lineage-head>..HEAD` yields exactly the /e/OS delta.

Legend — **F** feature-bearing, **S** security backports only, **B** build/CI/
licence only, **P** covered in a prebuilt repository instead.

| Project | Δ commits | Kind | Specified in |
|---|---:|:--:|---|
| `frameworks/base` | 185 | F+S | privacy/*, compatibility/*, system/system-ui, device/hardware-support |
| `vendor/lineage` | 66 | F | updates/release-types, branding/identity, updates/security-patches, system/lineage-features-removed |
| `packages/apps/Settings` | 62 | F | system/settings-organisation, system/advanced-privacy-entry, privacy/telemetry, identity/e-account |
| `packages/apps/Updater` | 59 | F | updates/ota-updater, updates/release-types |
| `packages/inputmethods/LatinIME` | 41 | F | system/keyboard |
| `packages/apps/SetupWizard` | 29 | F | setup/* |
| `vendor/apn` | 26 | F | connectivity/apn-database |
| `frameworks/libs/systemui` | 26 | F | system/notification-badges |
| `packages/modules/Nfc` | 21 | S | updates/security-patches |
| `packages/modules/Bluetooth` | 19 | S | updates/security-patches |
| `android` (manifest) | 18 | B | — |
| `packages/providers/MediaProvider` | 17 | S | updates/security-patches |
| `packages/modules/Permission` | 16 | F+S | compatibility/android-auto, device/hardware-support |
| `packages/apps/LineageParts` | 16 | F | system/lineage-features-removed, system/parental-control |
| `packages/apps/Contacts` | 13 | F | identity/e-account, system/telephony-and-messaging |
| `frameworks/av` | 12 | F+S | device/hardware-support |
| `packages/apps/Backgrounds` | 10 | F | branding/identity |
| `device/lineage/sepolicy` | 9 | F | privacy/tracker-blocking-dns, apps/default-permissions |
| `packages/services/Telephony` | 9 | F+S | privacy/degoogled-defaults |
| `external/libpng` | 8 | S | updates/security-patches |
| `packages/apps/Gallery2` | 7 | B | branding (icons/theme) |
| `bootable/recovery` | 6 | F | device/recovery |
| `lineage-sdk` | 6 | F | device/hardware-support |
| `packages/modules/DnsResolver` | 6 | F | privacy/tracker-blocking-dns |
| `frameworks/native` | 6 | F | device/hardware-support |
| `packages/apps/DocumentsUI` | 6 | B | apps/application-icons-and-theme |
| `packages/apps/ThemePicker` | 6 | F | system/lineage-features-removed |
| `packages/modules/Connectivity` | 5 | F | connectivity/network-defaults |
| `packages/apps/Dialer` | 5 | F | system/telephony-and-messaging |
| `build/soong` | 5 | F | updates/release-types, compatibility/play-integrity-compat, system/lineage-features-removed |
| `frameworks/opt/telephony` | 5 | S | updates/security-patches |
| `packages/overlays/Lineage` | 4 | F | apps/application-icons-and-theme |
| `packages/apps/WallpaperPicker2` | 4 | B | apps/application-icons-and-theme |
| `packages/apps/SettingsIntelligence` | 3 | B | apps/application-icons-and-theme |
| `packages/apps/FMRadio` | 3 | B | apps/application-icons-and-theme |
| `packages/apps/EmergencyInfo` | 3 | F | system/telephony-and-messaging |
| `frameworks/opt/vcard` | 3 | F | system/telephony-and-messaging |
| `vendor/qcom/.../fm` | 3 | B | apps/application-icons-and-theme |
| `system/core` | 2 | F | compatibility/play-integrity-compat |
| `packages/apps/Launcher3` → BlissLauncher3 | 328 | P | *BlissLauncher3 repository* |
| `external/prebuiltapks` | new | P | apps/preinstalled-applications (list only) |
| `vendor/eos` | new | F | apps/*, privacy/degoogled-defaults, compatibility/* |
| `external/ih8sn` | new | F | compatibility/play-integrity-compat |
| `packages/apps/elib` | new | F | apps/application-icons-and-theme |
| `external/svox` (PicoTTS) | new | F | apps/preinstalled-applications |
| `vendor/eos/flash` | new | F | device/flashing-package |

`packages/apps/TV`, `packages/apps/TvSettings` and `packages/apps/Car/Settings`
are forked but carry nothing on the /e/ side — there is no /e/OS TV or
automotive product — so they are deliberately unspecified.

Projects not listed carry only Android Security Bulletin backports and/or
CI/licence commits: `art`, `bionic`, `build/release`, `bootable/deprecated-ota`,
`development`, `external/{dng_sdk,exfatprogs,freetype,libhevc,libopenapv,sqlite,wpa_supplicant_8}`,
`hardware/{interfaces,nxp/nfc,nxp/secure_element,st/nfc}`,
`packages/apps/{Car/Settings,CertInstaller,ImsServiceEntitlement,KeyChain,ManagedProvisioning,TV,TvSettings}`,
`packages/modules/{adb,DnsResolver*,IntentResolver,Profiling,Uwb,Virtualization,Wifi}`,
`packages/providers/{ContactsProvider,DownloadProvider,TelephonyProvider}`,
`packages/services/{BuiltInPrintService,Telecomm}`,
`system/{apex,incremental_delivery,libfmq,libufdt,media}`.
They exist so /e/OS can ship the monthly bulletin ahead of LineageOS — see
`updates/security-patches.feature`.
