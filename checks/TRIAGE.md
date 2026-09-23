# Triage: what could prove each scenario

<!-- rows are added by checks/tools/gen-triage.py; the levels are written by hand and never overwritten by it -->

Deciding what could ever prove a scenario is a judgement, worth making once.
`unreviewed` means nobody has made it yet — it is not a level, it is a gap.

| level | meaning | scenarios |
|---|---|---|
| `measured` | only playing the scenario on the running application shows it | 164 |
| `observed` | querying the booted system is enough | 69 |
| `inspected` | reading the built image is enough | 56 |
| `repository` | provable against the repositories and the manifest, not the device | 25 |
| `unverifiable` | nothing can decide it mechanically | 34 |
| `unreviewed` | no judgement made yet | 0 |

| scenario | level | note |
|---|---|---|
| `@APP-1` | measured | colours in both themes need the screens rendered |
| `@APP-2` | inspected | which library the applications link against is a build fact |
| `@APP-3` | inspected | the palette values are resources in the image |
| `@APP-4` | observed | the resolved framework accent is readable from the running system |
| `@APP-5` | measured | the setup screens have to be reached |
| `@APP-6` | inspected | the adaptive icon mask is a resource |
| `@APP-7` | observed | two packages, queryable |
| `@APP-8` | measured | an update has to be installed for this to mean anything |
| `@APP-9` | observed | the WebView provider is queryable |
| `@APP-10` | observed | absence of the other browsers |
| `@APP-11` | inspected | which architecture's APK ships is a build fact |
| `@APP-12` | inspected | each carrying its own copy is a property of the image |
| `@APP-13` | measured | the offer only appears on a login form |
| `@APP-14` | measured | the passkey flow has to run |
| `@APP-15` | measured | same, with the key held elsewhere |
| `@APP-16` | measured | the user changes it, then it is honoured |
| `@APP-17` | observed | role assignments are queryable |
| `@APP-18` | measured | how the permission is shown is a settings screen |
| `@APP-19` | measured | the icon is rendered from the calendar's data |
| `@APP-20` | inspected | the required-application list is build configuration |
| `@APP-21` | inspected | same |
| `@APP-22` | observed | the application label is readable |
| `@APP-23` | inspected | the strings are resources in the image |
| `@APP-24` | measured | the absence of a splash screen is a launch behaviour |
| `@APP-25` | measured | which picker opens is a navigation result |
| `@APP-26` | observed | absence of a management client |
| `@APP-27` | measured | needs an enrolment to have happened |
| `@APP-28` | observed | granted permissions are queryable per package |
| `@APP-29` | measured | the revocation has to be performed, then honoured |
| `@APP-30` | observed | a fixed permission is visible in the package dump |
| `@APP-31` | observed | the battery-optimisation allowlist is queryable |
| `@APP-32` | observed | network permission on system applications |
| `@APP-33` | inspected | the SELinux rule is a policy file in the image |
| `@APP-34` | observed | the absence of a grant is queryable |
| `@APP-35` | inspected | the allowlists are XML files in the image |
| `@APP-36` | inspected | same |
| `@APP-37` | inspected | the relaxation is in the policy |
| `@APP-38` | measured | a work profile has to be created |
| `@APP-39` | measured | a clone profile has to be created |
| `@APP-40` | observed | the stopped state is queryable after first boot |
| `@APP-41` | repository | the committed version versus the shipped one |
| `@APP-42` | repository | how a prebuilt is updated is a repository practice |
| `@APP-43` | repository | LFS storage is a repository fact |
| `@APP-44` | repository | the per-version pinning is in the build files |
| `@APP-45` | repository | Blueprint declarations are build files |
| `@APP-46` | inspected | which prebuilts a reduced build ships |
| `@APP-47` | observed | the application set is queryable |
| `@APP-48` | observed | package names answering, queryable |
| `@APP-49` | observed | conditional on telephony, still a package query |
| `@APP-50` | inspected | what a minimal build leaves out is a build fact |
| `@APP-51` | observed | the screen reader package and its default role |
| `@APP-52` | observed | intent handlers are queryable |
| `@APP-53` | observed | absence of an MDM client |
| `@APP-54` | observed | absence of the LineageOS applications |
| `@APP-55` | inspected | package absence in the built image, per device tree |
| `@APP-56` | inspected | same |
| `@APP-57` | inspected | same |
| `@BRAND-1` | measured | the boot animation only exists while booting; a capture is the evidence |
| `@BRAND-2` | observed | version, description and release type are properties |
| `@BRAND-3` | observed | sounds are properties; the wallpaper needs the resolved resource |
| `@BRAND-4` | inspected | which wallpaper set ships is a build fact, per product |
| `@BRAND-5` | inspected | the file format of the shipped wallpapers |
| `@BRAND-6` | observed | product name and model are properties |
| `@BRAND-7` | observed | two devices queried side by side |
| `@BRAND-8` | measured | only browsing the screens shows what text they carry |
| `@COMPAT-1` | measured | an APK has to be installed for the check to run |
| `@COMPAT-2` | measured | the grant only exists once installed |
| `@COMPAT-3` | measured | same, for the permission not granted |
| `@COMPAT-4` | measured | Android Auto has to start |
| `@COMPAT-5` | observed | the automotive role is queryable |
| `@COMPAT-6` | observed | the companion device allowlist is queryable |
| `@COMPAT-7` | measured | the refusal happens at install time |
| `@COMPAT-8` | measured | same |
| `@COMPAT-9` | measured | same |
| `@COMPAT-10` | measured | verification is a runtime fetch |
| `@COMPAT-11` | measured | opening a link is a navigation result |
| `@COMPAT-12` | measured | same, for a site that opts out |
| `@COMPAT-13` | measured | installer attribution only exists after an install |
| `@COMPAT-14` | measured | the absence of per-app confirmation is a flow |
| `@COMPAT-15` | measured | link handling without a disambiguation dialog |
| `@COMPAT-16` | measured | attribution for another installer |
| `@COMPAT-17` | inspected | microG feature flags are in microg.xml in the image |
| `@COMPAT-18` | inspected | same |
| `@COMPAT-19` | inspected | same |
| `@COMPAT-20` | inspected | same |
| `@COMPAT-21` | inspected | same |
| `@COMPAT-22` | inspected | same |
| `@COMPAT-23` | inspected | same |
| `@COMPAT-24` | inspected | same |
| `@COMPAT-25` | inspected | same |
| `@COMPAT-26` | inspected | the allowlist is an XML file in the image |
| `@COMPAT-27` | inspected | same, for the narrower store stub set |
| `@COMPAT-28` | measured | signature spoofing only happens at query time |
| `@COMPAT-29` | measured | the refusal for a third party is runtime |
| `@COMPAT-30` | inspected | the allowed list is a configuration file |
| `@COMPAT-31` | observed | the accepted location provider is queryable |
| `@COMPAT-32` | measured | Doze behaviour needs the device idle |
| `@COMPAT-33` | observed | the enabled microG features are readable once running |
| `@COMPAT-34` | measured | the settings entry leads somewhere |
| `@COMPAT-35` | observed | the reported fingerprint and model are properties |
| `@COMPAT-36` | measured | attestation has to be requested |
| `@COMPAT-37` | measured | a legitimate attestation has to be served |
| `@COMPAT-38` | observed | the verified boot state is a property |
| `@COMPAT-39` | observed | the build number is a property |
| `@COMPAT-40` | inspected | whether the daemon ships is a build fact |
| `@COMPAT-41` | inspected | same |
| `@COMPAT-42` | inspected | same |
| `@COMPAT-43` | inspected | the per-device configuration is a file in the image |
| `@COMPAT-44` | observed | the reported values are properties |
| `@COMPAT-45` | observed | comparing two builds' properties |
| `@COMPAT-46` | observed | the displayed variant is a property |
| `@DEV-1` | inspected | the archive is produced by the build |
| `@DEV-2` | inspected | its contents are readable |
| `@DEV-3` | inspected | which fastboot is bundled |
| `@DEV-4` | unverifiable | requires a real device in fastboot; no emulator equivalent |
| `@DEV-5` | unverifiable | requires a locked bootloader |
| `@DEV-6` | unverifiable | same |
| `@DEV-7` | unverifiable | requires a flash to fail on hardware |
| `@DEV-8` | unverifiable | requires the device's own flashing sequence |
| `@DEV-9` | unverifiable | requires a real flash |
| `@DEV-10` | unverifiable | requires the rollback index on hardware |
| `@DEV-11` | unverifiable | requires a real device to reboot |
| `@DEV-12` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-13` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-14` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-15` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-16` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-17` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-18` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-19` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-20` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-21` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-22` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-23` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-24` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-25` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-26` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-27` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-28` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-29` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-30` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-31` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-32` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-33` | unverifiable | needs the hardware this describes; no emulator equivalent |
| `@DEV-34` | inspected | the emulator's partition sizes are a build fact |
| `@DEV-35` | unverifiable | the recovery is a separate image, not reachable from Android |
| `@DEV-36` | unverifiable | same |
| `@DEV-37` | unverifiable | same |
| `@DEV-38` | unverifiable | same |
| `@DEV-39` | measured | that the wizard never offers it is part of the walk |
| `@ID-1` | observed | entry position in the settings hierarchy |
| `@ID-2` | measured | ordering in the accounts list needs the screen |
| `@ID-3` | measured | which application opens is a navigation result |
| `@ID-4` | observed | granted permissions |
| `@ID-5` | measured | preselection is visible in the editor |
| `@ID-6` | measured | the saved contact has to be created and read back |
| `@ID-7` | measured | duplicate address books show on the screen |
| `@ID-8` | measured | the dialog text has to be raised |
| `@ID-9` | measured | the description is on a settings screen |
| `@NET-1` | measured | APN selection happens against a carrier |
| `@NET-2` | inspected | the MVNO entry exists in the shipped database |
| `@NET-3` | repository | whether /e/OS carries the correction is a repository fact |
| `@NET-4` | inspected | which database ships is a build fact |
| `@NET-5` | repository | schema validation is a CI step on the database |
| `@NET-6` | measured | what the picker offers needs the screen |
| `@NET-7` | measured | what tethered clients receive is runtime |
| `@NET-8` | measured | the diagnostic target is only visible when it runs |
| `@NET-9` | measured | the suggested value is on a screen |
| `@NET-10` | observed | the scan exemption is queryable |
| `@PRIV-1` | inspected | the NTP host is a configuration value in the image |
| `@PRIV-2` | inspected | the default DNS is a configuration value |
| `@PRIV-3` | measured | what the private DNS picker offers needs the screen |
| `@PRIV-4` | inspected | the captive portal URLs are configuration values |
| `@PRIV-5` | inspected | the entitlement host is a configuration value |
| `@PRIV-6` | observed | which provider is registered is queryable |
| `@PRIV-7` | measured | the privacy indicator appears while locating |
| `@PRIV-8` | measured | the address lookup flow has to run |
| `@PRIV-9` | measured | the absence of a link needs the screens browsed |
| `@PRIV-10` | measured | registration only happens at runtime |
| `@PRIV-11` | measured | same, for a carrier that needs it |
| `@PRIV-12` | measured | the faked coordinates only exist at request time |
| `@PRIV-13` | measured | same, for an unaffected application |
| `@PRIV-14` | measured | updates have to be delivered |
| `@PRIV-15` | measured | the geofence has to be evaluated |
| `@PRIV-16` | measured | the per-caller resolution happens at request time |
| `@PRIV-17` | measured | the fallback to the real location |
| `@PRIV-18` | observed | that Advanced Privacy is a system application is queryable |
| `@PRIV-19` | measured | the package query result depends on the caller |
| `@PRIV-20` | measured | same |
| `@PRIV-21` | measured | same, with several applications |
| `@PRIV-22` | measured | taking effect without a reboot is a runtime property |
| `@PRIV-23` | measured | per-user behaviour needs two users |
| `@PRIV-24` | observed | the setting's visibility is queryable |
| `@PRIV-25` | measured | an empty list hiding nothing is a runtime result |
| `@PRIV-26` | measured | the absence of a setup screen is the walk |
| `@PRIV-27` | measured | the absence of a settings entry |
| `@PRIV-28` | observed | the default switch state is a setting |
| `@PRIV-29` | measured | the choice has to be made, then stored |
| `@PRIV-30` | measured | the identifier is displayed on a screen |
| `@PRIV-31` | measured | stability across reboots needs two reboots |
| `@PRIV-32` | measured | the grouping is a developer options screen |
| `@PRIV-33` | measured | the resolver's interaction with the blocker is runtime |
| `@PRIV-34` | measured | same |
| `@PRIV-35` | measured | per-application decisions at resolution time |
| `@PRIV-36` | measured | behaviour when the blocker is absent |
| `@PRIV-37` | measured | behaviour when it does not answer |
| `@PRIV-38` | measured | early boot resolution |
| `@PRIV-39` | inspected | the SELinux rule is a policy file |
| `@PROC-1` | repository | the upstream merge is visible in the branch history |
| `@PROC-2` | repository | the AOSP tag is read from the manifest of the branch |
| `@PROC-3` | repository | a failed merge leaves the branch on its last good state |
| `@PROC-4` | repository | which branches the pipeline runs on is CI configuration |
| `@PROC-5` | repository | the branch point is a git fact |
| `@PROC-6` | repository | the branch point is a git fact |
| `@PROC-7` | repository | merge requests on top vs a merge from the previous generation |
| `@PROC-8` | repository | this is the closure check: diff against upstream is the /e/OS work |
| `@PROC-9` | repository | the binding is declared in the manifest |
| `@PROC-10` | repository | the automatic merge-back is a pipeline job |
| `@PROC-11` | repository | the absence of that job on other branches |
| `@PROC-12` | repository | which branches carry a fork is readable from the manifests |
| `@PROC-13` | repository | same, for the release branch |
| `@PROC-14` | repository | comparing the fork counts of two manifests |
| `@SETUP-1` | measured | the step is offered only once an account exists |
| `@SETUP-2` | measured | the account has to be registered before the restore |
| `@SETUP-3` | measured | the absence of the step without an account |
| `@SETUP-4` | measured | the short-circuit is a traversal difference |
| `@SETUP-5` | measured | declining keeps the normal sequence |
| `@SETUP-6` | measured | the toggle state after the wizard, on a locked device |
| `@SETUP-7` | measured | same, left alone when unlocked |
| `@SETUP-8` | measured | enrolment from a QR code is a flow |
| `@SETUP-9` | measured | the signature check happens during provisioning |
| `@SETUP-10` | measured | an already provisioned device not starting again |
| `@SETUP-11` | measured | the welcome screen has to be reached and read |
| `@SETUP-12` | measured | the order is the sequence the walk traverses |
| `@SETUP-13` | measured | the two options only exist on the screen |
| `@SETUP-14` | measured | requires an account attached, then the screen re-read |
| `@SETUP-15` | measured | the toggle is on a wizard screen; the setting it writes is observed |
| `@SETUP-16` | measured | that the step is offered, and skippable, is the walk |
| `@SETUP-17` | measured | same, and it self-skips without telephony |
| `@SETUP-18` | observed | the default home application is a role, queryable |
| `@SETUP-19` | measured | that a step is never offered can only be seen by walking |
| `@SETUP-20` | measured | layout in two orientations needs the screen rendered |
| `@SETUP-21` | inspected | the translated strings are resources in the image |
| `@SYS-1` | observed | the entry's presence is in the settings hierarchy |
| `@SYS-2` | measured | what opens is a navigation result |
| `@SYS-3` | measured | search results only exist when searched |
| `@SYS-4` | observed | entry presence |
| `@SYS-5` | observed | absence of the Google entry |
| `@SYS-6` | measured | the wizard step has to be reached |
| `@SYS-7` | observed | granted permissions are queryable |
| `@SYS-8` | inspected | the translated strings are resources |
| `@SYS-9` | measured | dictation has to be invoked |
| `@SYS-10` | measured | the absence of a paywall is a launch behaviour |
| `@SYS-11` | observed | the key's default state is a setting |
| `@SYS-12` | measured | the button is on the suggestion strip, rendered |
| `@SYS-13` | observed | the emoji key default is a setting |
| `@SYS-14` | measured | re-theming on a configuration change has to be triggered |
| `@SYS-15` | observed | granted permissions |
| `@SYS-16` | inspected | which OTA certificate ships is a build fact |
| `@SYS-17` | measured | what a help link points at needs the screen |
| `@SYS-18` | measured | the contributors screen has to be opened |
| `@SYS-19` | measured | the dialog has to be raised |
| `@SYS-20` | measured | the entry label is on a settings screen |
| `@SYS-21` | observed | the package's presence and its settings entry |
| `@SYS-22` | inspected | addon.d scripts are files in the image |
| `@SYS-23` | repository | which makefiles the build inherits |
| `@SYS-24` | measured | the absence of an option in the picker |
| `@SYS-25` | measured | the badge is drawn; only rendering shows its shape |
| `@SYS-26` | measured | same |
| `@SYS-27` | measured | same, with the abbreviated text |
| `@SYS-28` | measured | the shadow is a rendering property |
| `@SYS-29` | measured | sizing per form factor, rendered |
| `@SYS-30` | measured | the taskbar dot is drawn |
| `@SYS-31` | measured | the absence of a count is a rendering fact |
| `@SYS-32` | measured | the composed icon is drawn from the date |
| `@SYS-33` | measured | enabling it is an action that is accepted |
| `@SYS-34` | measured | the refusal happens at the attempt |
| `@SYS-35` | observed | entry presence |
| `@SYS-36` | measured | the explanation is shown when the restriction bites |
| `@SYS-37` | measured | the absence of the options in the power menu |
| `@SYS-38` | measured | the wizard step has to be reached |
| `@SYS-39` | observed | granted permissions |
| `@SYS-40` | observed | entry order in the settings hierarchy |
| `@SYS-41` | measured | the absence of a card is a rendering fact |
| `@SYS-42` | measured | same for placeholders |
| `@SYS-43` | measured | the title is on the settings screen |
| `@SYS-44` | measured | the legal screen has to be opened |
| `@SYS-45` | measured | where feedback is addressed needs the flow |
| `@SYS-46` | measured | icon rendering |
| `@SYS-47` | measured | what is visible without scrolling, on a tablet |
| `@SYS-48` | observed | whether Monet is disabled is a setting or a resolved resource |
| `@SYS-49` | observed | the resolved system accent |
| `@SYS-50` | measured | completeness of both themes across surfaces, rendered |
| `@SYS-51` | measured | survival across a configuration change |
| `@SYS-52` | observed | the initial theme mode is a setting |
| `@SYS-53` | measured | absence of a quick settings tile |
| `@SYS-54` | measured | which application opens a screenshot |
| `@SYS-55` | measured | absence of an action in the screenshot UI |
| `@SYS-56` | observed | notification listener access is queryable |
| `@SYS-57` | measured | the key long-press behaviour |
| `@SYS-58` | measured | the SIM name on the keyguard, rendered |
| `@SYS-59` | observed | mobile data enabled is a setting on first boot |
| `@SYS-60` | observed | the call recording default is a resource value |
| `@SYS-61` | inspected | which audio source is used is a configuration value |
| `@SYS-62` | measured | absence of a dialer button |
| `@SYS-63` | measured | the export flow offers the choice |
| `@SYS-64` | measured | the exported file has to be produced and read |
| `@SYS-65` | measured | labels rendered on the contact screen |
| `@SYS-66` | measured | the unlock prompt happens on access |
| `@UPD-1` | measured | the query only happens when the updater runs |
| `@UPD-2` | measured | what the request carries is observable only when it is sent |
| `@UPD-3` | observed | the entry's position is in the settings hierarchy |
| `@UPD-4` | measured | the daily schedule is a job the updater registers |
| `@UPD-5` | measured | release notes are fetched and rendered |
| `@UPD-6` | measured | requires an update to be offered |
| `@UPD-7` | measured | requires an older update to be present and not listed |
| `@UPD-8` | measured | the refusal only happens at install time |
| `@UPD-9` | measured | the refusal only happens at install time |
| `@UPD-10` | measured | resuming needs connectivity to change mid-download |
| `@UPD-11` | measured | needs a real A/B install |
| `@UPD-12` | measured | the notification exists only after an install |
| `@UPD-13` | measured | deletion happens after a successful install |
| `@UPD-14` | measured | what is listed is the updater's own filtering |
| `@UPD-15` | measured | a local file has to be offered and validated |
| `@UPD-16` | measured | needs a management client reading the reported state |
| `@UPD-17` | observed | the staging toggle is a setting; what it changes is measured |
| `@UPD-18` | measured | the relaxed query is only visible when sent |
| `@UPD-19` | observed | the release type is a property |
| `@UPD-20` | observed | the fallback is visible in the property |
| `@UPD-21` | observed | same |
| `@UPD-22` | observed | the identifier appears in the version property |
| `@UPD-23` | observed | the version string is a property |
| `@UPD-24` | observed | the prerelease name is in the version property |
| `@UPD-25` | observed | the pipeline identifier is in the version property |
| `@UPD-26` | measured | what the request carries is only visible when sent |
| `@UPD-27` | measured | the refusal happens in the updater |
| `@UPD-28` | measured | channel independence needs updates of both types |
| `@UPD-29` | inspected | whether the daemon ships is a build fact |
| `@UPD-30` | inspected | same |
| `@UPD-31` | inspected | same |
| `@UPD-32` | inspected | the OTA certificate is a file in the image |
| `@UPD-33` | inspected | same |
| `@UPD-34` | repository | the keys are declared in the build configuration |
| `@UPD-35` | observed | the patch level is a property |
| `@UPD-36` | measured | the wording is on a settings screen |
| `@UPD-37` | measured | what is displayed alongside needs the screen |
| `@UPD-38` | repository | which bulletin a release carries is a branch fact |
| `@UPD-39` | repository | comparing two release branches |
