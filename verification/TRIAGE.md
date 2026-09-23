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
| `@APP-1` | unreviewed |  |
| `@APP-2` | unreviewed |  |
| `@APP-3` | unreviewed |  |
| `@APP-4` | unreviewed |  |
| `@APP-5` | unreviewed |  |
| `@APP-6` | unreviewed |  |
| `@APP-7` | unreviewed |  |
| `@APP-8` | unreviewed |  |
| `@APP-9` | unreviewed |  |
| `@APP-10` | unreviewed |  |
| `@APP-11` | unreviewed |  |
| `@APP-12` | unreviewed |  |
| `@APP-13` | unreviewed |  |
| `@APP-14` | unreviewed |  |
| `@APP-15` | unreviewed |  |
| `@APP-16` | unreviewed |  |
| `@APP-17` | unreviewed |  |
| `@APP-18` | unreviewed |  |
| `@APP-19` | unreviewed |  |
| `@APP-20` | unreviewed |  |
| `@APP-21` | unreviewed |  |
| `@APP-22` | unreviewed |  |
| `@APP-23` | unreviewed |  |
| `@APP-24` | unreviewed |  |
| `@APP-25` | unreviewed |  |
| `@APP-26` | unreviewed |  |
| `@APP-27` | unreviewed |  |
| `@APP-28` | unreviewed |  |
| `@APP-29` | unreviewed |  |
| `@APP-30` | unreviewed |  |
| `@APP-31` | unreviewed |  |
| `@APP-32` | unreviewed |  |
| `@APP-33` | unreviewed |  |
| `@APP-34` | unreviewed |  |
| `@APP-35` | unreviewed |  |
| `@APP-36` | unreviewed |  |
| `@APP-37` | unreviewed |  |
| `@APP-38` | unreviewed |  |
| `@APP-39` | unreviewed |  |
| `@APP-40` | unreviewed |  |
| `@APP-41` | unreviewed |  |
| `@APP-42` | unreviewed |  |
| `@APP-43` | unreviewed |  |
| `@APP-44` | unreviewed |  |
| `@APP-45` | unreviewed |  |
| `@APP-46` | unreviewed |  |
| `@APP-47` | unreviewed |  |
| `@APP-48` | unreviewed |  |
| `@APP-49` | unreviewed |  |
| `@APP-50` | unreviewed |  |
| `@APP-51` | unreviewed |  |
| `@APP-52` | unreviewed |  |
| `@APP-53` | unreviewed |  |
| `@APP-54` | unreviewed |  |
| `@APP-55` | unreviewed |  |
| `@APP-56` | unreviewed |  |
| `@APP-57` | unreviewed |  |
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
| `@SYS-1` | unreviewed |  |
| `@SYS-2` | unreviewed |  |
| `@SYS-3` | unreviewed |  |
| `@SYS-4` | unreviewed |  |
| `@SYS-5` | unreviewed |  |
| `@SYS-6` | unreviewed |  |
| `@SYS-7` | unreviewed |  |
| `@SYS-8` | unreviewed |  |
| `@SYS-9` | unreviewed |  |
| `@SYS-10` | unreviewed |  |
| `@SYS-11` | unreviewed |  |
| `@SYS-12` | unreviewed |  |
| `@SYS-13` | unreviewed |  |
| `@SYS-14` | unreviewed |  |
| `@SYS-15` | unreviewed |  |
| `@SYS-16` | unreviewed |  |
| `@SYS-17` | unreviewed |  |
| `@SYS-18` | unreviewed |  |
| `@SYS-19` | unreviewed |  |
| `@SYS-20` | unreviewed |  |
| `@SYS-21` | unreviewed |  |
| `@SYS-22` | unreviewed |  |
| `@SYS-23` | unreviewed |  |
| `@SYS-24` | unreviewed |  |
| `@SYS-25` | unreviewed |  |
| `@SYS-26` | unreviewed |  |
| `@SYS-27` | unreviewed |  |
| `@SYS-28` | unreviewed |  |
| `@SYS-29` | unreviewed |  |
| `@SYS-30` | unreviewed |  |
| `@SYS-31` | unreviewed |  |
| `@SYS-32` | unreviewed |  |
| `@SYS-33` | unreviewed |  |
| `@SYS-34` | unreviewed |  |
| `@SYS-35` | unreviewed |  |
| `@SYS-36` | unreviewed |  |
| `@SYS-37` | unreviewed |  |
| `@SYS-38` | unreviewed |  |
| `@SYS-39` | unreviewed |  |
| `@SYS-40` | unreviewed |  |
| `@SYS-41` | unreviewed |  |
| `@SYS-42` | unreviewed |  |
| `@SYS-43` | unreviewed |  |
| `@SYS-44` | unreviewed |  |
| `@SYS-45` | unreviewed |  |
| `@SYS-46` | unreviewed |  |
| `@SYS-47` | unreviewed |  |
| `@SYS-48` | unreviewed |  |
| `@SYS-49` | unreviewed |  |
| `@SYS-50` | unreviewed |  |
| `@SYS-51` | unreviewed |  |
| `@SYS-52` | unreviewed |  |
| `@SYS-53` | unreviewed |  |
| `@SYS-54` | unreviewed |  |
| `@SYS-55` | unreviewed |  |
| `@SYS-56` | unreviewed |  |
| `@SYS-57` | unreviewed |  |
| `@SYS-58` | unreviewed |  |
| `@SYS-59` | unreviewed |  |
| `@SYS-60` | unreviewed |  |
| `@SYS-61` | unreviewed |  |
| `@SYS-62` | unreviewed |  |
| `@SYS-63` | unreviewed |  |
| `@SYS-64` | unreviewed |  |
| `@SYS-65` | unreviewed |  |
| `@SYS-66` | unreviewed |  |
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
