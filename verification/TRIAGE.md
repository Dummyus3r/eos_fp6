# Triage: what could prove each scenario

<!-- rows are added by verification/tools/gen-triage.py; the levels are written by hand and never overwritten by it -->

Deciding what could ever prove a scenario is a judgement, worth making once.
`unreviewed` means nobody has made it yet — it is not a level, it is a gap.

| level | meaning | scenarios |
|---|---|---|
| `measured` | only playing the scenario on the running application shows it | 0 |
| `observed` | querying the booted system is enough | 0 |
| `inspected` | reading the built image is enough | 0 |
| `unverifiable` | no device-level evidence exists for it | 0 |
| `unreviewed` | no judgement made yet | 348 |

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
| `@COMPAT-1` | unreviewed |  |
| `@COMPAT-2` | unreviewed |  |
| `@COMPAT-3` | unreviewed |  |
| `@COMPAT-4` | unreviewed |  |
| `@COMPAT-5` | unreviewed |  |
| `@COMPAT-6` | unreviewed |  |
| `@COMPAT-7` | unreviewed |  |
| `@COMPAT-8` | unreviewed |  |
| `@COMPAT-9` | unreviewed |  |
| `@COMPAT-10` | unreviewed |  |
| `@COMPAT-11` | unreviewed |  |
| `@COMPAT-12` | unreviewed |  |
| `@COMPAT-13` | unreviewed |  |
| `@COMPAT-14` | unreviewed |  |
| `@COMPAT-15` | unreviewed |  |
| `@COMPAT-16` | unreviewed |  |
| `@COMPAT-17` | unreviewed |  |
| `@COMPAT-18` | unreviewed |  |
| `@COMPAT-19` | unreviewed |  |
| `@COMPAT-20` | unreviewed |  |
| `@COMPAT-21` | unreviewed |  |
| `@COMPAT-22` | unreviewed |  |
| `@COMPAT-23` | unreviewed |  |
| `@COMPAT-24` | unreviewed |  |
| `@COMPAT-25` | unreviewed |  |
| `@COMPAT-26` | unreviewed |  |
| `@COMPAT-27` | unreviewed |  |
| `@COMPAT-28` | unreviewed |  |
| `@COMPAT-29` | unreviewed |  |
| `@COMPAT-30` | unreviewed |  |
| `@COMPAT-31` | unreviewed |  |
| `@COMPAT-32` | unreviewed |  |
| `@COMPAT-33` | unreviewed |  |
| `@COMPAT-34` | unreviewed |  |
| `@COMPAT-35` | unreviewed |  |
| `@COMPAT-36` | unreviewed |  |
| `@COMPAT-37` | unreviewed |  |
| `@COMPAT-38` | unreviewed |  |
| `@COMPAT-39` | unreviewed |  |
| `@COMPAT-40` | unreviewed |  |
| `@COMPAT-41` | unreviewed |  |
| `@COMPAT-42` | unreviewed |  |
| `@COMPAT-43` | unreviewed |  |
| `@COMPAT-44` | unreviewed |  |
| `@COMPAT-45` | unreviewed |  |
| `@COMPAT-46` | unreviewed |  |
| `@DEV-1` | unreviewed |  |
| `@DEV-2` | unreviewed |  |
| `@DEV-3` | unreviewed |  |
| `@DEV-4` | unreviewed |  |
| `@DEV-5` | unreviewed |  |
| `@DEV-6` | unreviewed |  |
| `@DEV-7` | unreviewed |  |
| `@DEV-8` | unreviewed |  |
| `@DEV-9` | unreviewed |  |
| `@DEV-10` | unreviewed |  |
| `@DEV-11` | unreviewed |  |
| `@DEV-12` | unreviewed |  |
| `@DEV-13` | unreviewed |  |
| `@DEV-14` | unreviewed |  |
| `@DEV-15` | unreviewed |  |
| `@DEV-16` | unreviewed |  |
| `@DEV-17` | unreviewed |  |
| `@DEV-18` | unreviewed |  |
| `@DEV-19` | unreviewed |  |
| `@DEV-20` | unreviewed |  |
| `@DEV-21` | unreviewed |  |
| `@DEV-22` | unreviewed |  |
| `@DEV-23` | unreviewed |  |
| `@DEV-24` | unreviewed |  |
| `@DEV-25` | unreviewed |  |
| `@DEV-26` | unreviewed |  |
| `@DEV-27` | unreviewed |  |
| `@DEV-28` | unreviewed |  |
| `@DEV-29` | unreviewed |  |
| `@DEV-30` | unreviewed |  |
| `@DEV-31` | unreviewed |  |
| `@DEV-32` | unreviewed |  |
| `@DEV-33` | unreviewed |  |
| `@DEV-34` | unreviewed |  |
| `@DEV-35` | unreviewed |  |
| `@DEV-36` | unreviewed |  |
| `@DEV-37` | unreviewed |  |
| `@DEV-38` | unreviewed |  |
| `@DEV-39` | unreviewed |  |
| `@ID-1` | unreviewed |  |
| `@ID-2` | unreviewed |  |
| `@ID-3` | unreviewed |  |
| `@ID-4` | unreviewed |  |
| `@ID-5` | unreviewed |  |
| `@ID-6` | unreviewed |  |
| `@ID-7` | unreviewed |  |
| `@ID-8` | unreviewed |  |
| `@ID-9` | unreviewed |  |
| `@NET-1` | unreviewed |  |
| `@NET-2` | unreviewed |  |
| `@NET-3` | unreviewed |  |
| `@NET-4` | unreviewed |  |
| `@NET-5` | unreviewed |  |
| `@NET-6` | unreviewed |  |
| `@NET-7` | unreviewed |  |
| `@NET-8` | unreviewed |  |
| `@NET-9` | unreviewed |  |
| `@NET-10` | unreviewed |  |
| `@PRIV-1` | unreviewed |  |
| `@PRIV-2` | unreviewed |  |
| `@PRIV-3` | unreviewed |  |
| `@PRIV-4` | unreviewed |  |
| `@PRIV-5` | unreviewed |  |
| `@PRIV-6` | unreviewed |  |
| `@PRIV-7` | unreviewed |  |
| `@PRIV-8` | unreviewed |  |
| `@PRIV-9` | unreviewed |  |
| `@PRIV-10` | unreviewed |  |
| `@PRIV-11` | unreviewed |  |
| `@PRIV-12` | unreviewed |  |
| `@PRIV-13` | unreviewed |  |
| `@PRIV-14` | unreviewed |  |
| `@PRIV-15` | unreviewed |  |
| `@PRIV-16` | unreviewed |  |
| `@PRIV-17` | unreviewed |  |
| `@PRIV-18` | unreviewed |  |
| `@PRIV-19` | unreviewed |  |
| `@PRIV-20` | unreviewed |  |
| `@PRIV-21` | unreviewed |  |
| `@PRIV-22` | unreviewed |  |
| `@PRIV-23` | unreviewed |  |
| `@PRIV-24` | unreviewed |  |
| `@PRIV-25` | unreviewed |  |
| `@PRIV-26` | unreviewed |  |
| `@PRIV-27` | unreviewed |  |
| `@PRIV-28` | unreviewed |  |
| `@PRIV-29` | unreviewed |  |
| `@PRIV-30` | unreviewed |  |
| `@PRIV-31` | unreviewed |  |
| `@PRIV-32` | unreviewed |  |
| `@PRIV-33` | unreviewed |  |
| `@PRIV-34` | unreviewed |  |
| `@PRIV-35` | unreviewed |  |
| `@PRIV-36` | unreviewed |  |
| `@PRIV-37` | unreviewed |  |
| `@PRIV-38` | unreviewed |  |
| `@PRIV-39` | unreviewed |  |
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
| `@SETUP-1` | unreviewed |  |
| `@SETUP-2` | unreviewed |  |
| `@SETUP-3` | unreviewed |  |
| `@SETUP-4` | unreviewed |  |
| `@SETUP-5` | unreviewed |  |
| `@SETUP-6` | unreviewed |  |
| `@SETUP-7` | unreviewed |  |
| `@SETUP-8` | unreviewed |  |
| `@SETUP-9` | unreviewed |  |
| `@SETUP-10` | unreviewed |  |
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
