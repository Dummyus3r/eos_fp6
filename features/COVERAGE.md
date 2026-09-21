# Coverage of the /e/OS forks

For the per-repository view of *what* /e/OS changes in each project, see
[`BY-REPOSITORY.md`](BY-REPOSITORY.md). This file is the audit of *whether*
every fork is covered at all.

Configuration files are a coverage trap alongside resource overlays: a default
shipped as an XML map (`GmsCore/microg.xml`) or a privileged permission
allowlist changes behaviour with no code and no descriptive commit. Those were
swept too — `privapp-permissions-*`, `permissions_*`, `allowlist_*`,
`whitelist_*`, `default-permissions_*`, `preinstalled-packages-*`,
`initial-package-stopped-states-*`.

Resource overlays are a coverage trap: behaviour that lives only in an RRO or
an overlaid `config.xml` has no commit message describing it. The overlay
surfaces were therefore swept exhaustively — `vendor/eos/overlay`,
`vendor/lineage/overlay`, `packages/overlays/Lineage`,
`external/prebuiltapks/**/rro_overlays` — and the role assignments they carry
are specified in `apps/default-app-associations.feature`.

Cross-checked against the Android 16 porting epic
(https://gitlab.e.foundation/groups/e/os/-/work_items/211). Every area the epic
lists is either specified here, recorded below as deliberately not forked, or
listed in `TODO.md` as living outside this tree.

Reference: the `v4.3-a16` manifest. The `a16` development manifest forks fewer
projects — the extra forks on `v4.3-a16` exist to carry the monthly security
patch — and adds `hardware/qcom-caf/thermal`, which is therefore not covered.

Method: every `<project>` of `snippets/eos.xml` was diffed against its LineageOS
counterpart (`lineage-23` checkout, same path). Since /e/OS merges LineageOS
regularly, the LineageOS HEAD is an ancestor of the /e/OS HEAD for most
projects, so `git log <lineage-head>..HEAD` yields exactly the /e/OS delta.

A project with no LineageOS counterpart — `vendor/eos`, `external/prebuiltapks`
and the others marked `new` below — has no base to diff against: its entire
content is the /e/OS delta. Such a project therefore yields no commit list, and
anything derived from this document that expects one (a "commits to port"
section, for instance) comes out empty for it. That emptiness means
*everything*, not *nothing*.

Legend — **F** feature-bearing, **S** security backports only, **B** build/CI/
licence only, **P** covered in a prebuilt repository instead. `new` in the
Δ commits column — the project has no LineageOS counterpart, so there is no
delta to count.

| Project | Δ commits | Kind | Specified in |
|---|---:|:--:|---|
| `frameworks/base` | 185 | F+S | privacy/*, compatibility/*, system/system-ui, device/hardware-support |
| `vendor/lineage` | 66 | F | updates/release-types, branding/identity, updates/security-patches, system/lineage-features-removed |
| `packages/apps/Settings` | 62 | F | system/settings-organisation, system/advanced-privacy-entry, privacy/telemetry, identity/murena-workspace-account |
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
| `packages/apps/Contacts` | 13 | F | identity/murena-workspace-account, system/telephony-and-messaging |
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
| `.gitlab-ci.yml` in 83 forked projects | — | F | process/fork-maintenance |
| `packages/apps/ImsServiceEntitlement` | 3 | F | privacy/degoogled-defaults |
| `bootable/deprecated-ota` | 3 | F | device/recovery |
| `external/prebuiltapks/Browser` | new | F | apps/browser-and-webview |
| `external/prebuiltapks/rro_overlays`, `Glimpse/rro_overlays`, `mapsOverlay` | new | F | apps/default-app-associations |
| `external/prebuiltapks/GmsCore/microg.xml` | new | F | compatibility/microg-configuration |
| `external/prebuiltapks/*/privapp-permissions-*.xml` etc. (19 files) | new | F | apps/default-permissions |
| `vendor/eos/overlay/rro_overlays` | new | F | apps/default-app-associations |

`packages/apps/TV`, `packages/apps/TvSettings` and `packages/apps/Car/Settings`
are forked but carry nothing on the /e/OS side — there is no /e/OS TV or
automotive product — so they are deliberately unspecified.

`build/make` is deliberately **not** forked — /e/OS uses LineageOS's. The fork
that once existed was dropped ("Remove unused build repo" in the manifest), so
the epic's `android_build` item has no counterpart to specify.

Projects not listed carry only Android Security Bulletin backports and/or
CI/licence commits: `art`, `bionic`, `build/release`,
`development`, `external/{dng_sdk,exfatprogs,freetype,libhevc,libopenapv,sqlite,wpa_supplicant_8}`,
`hardware/{interfaces,nxp/nfc,nxp/secure_element,st/nfc}`,
`packages/apps/{Car/Settings,CertInstaller,KeyChain,ManagedProvisioning,TV,TvSettings}`,
`packages/modules/{adb,DnsResolver*,IntentResolver,Profiling,Uwb,Virtualization,Wifi}`,
`packages/providers/{ContactsProvider,DownloadProvider,TelephonyProvider}`,
`packages/services/{BuiltInPrintService,Telecomm}`,
`system/{apex,incremental_delivery,libfmq,libufdt,media}`.
They exist so /e/OS can ship the monthly bulletin ahead of LineageOS — see
`updates/security-patches.feature`.
