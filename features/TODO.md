# Open questions

## Decisions taken (first pass review)

Recorded here so the next pass does not re-litigate them.

| Question | Decision |
|---|---|
| Language | English. |
| Reference branch | `v4.3-a16`. The `a16` development manifest forks fewer projects; the extra forks on `v4.3-a16` exist to carry the monthly security patch. |
| Executable or documentary | Documentary for now. |
| Version tagging per feature | No. Features will be traced through the manifest, which gives the version when it is needed. |
| One scenario per CVE | No. One file for the security-patch policy. |
| Prebuilt boundary | Correct as drawn: system-side contract here, behaviour in the application repository, `@prebuilt-boundary` on the boundary. |
| `frameworks/libs/systemui` badges | Stay here, as a platform contract, not in the BlissLauncher3 repository. |
| Partner hardware enablement | In scope. Specified in `device/hardware-support.feature`. |
| Theming | One file for everything theme-related. |
| Reverted work | Describe the tree as it stands, after the revert. |
| Telemetry in developer options | Deliberate. |
| Flashing scripts | In scope — users flashing by hand depend on them. `device/flashing-package.feature`. |
| Prebuilt update policy | Manual, by hand. Recorded in `apps/prebuilt-maintenance.feature`. |
| `packages/apps/TV`, `TvSettings`, `Car/Settings` | Nothing on the /e/ side. Not specified. |
| Release-type-dependent behaviour | Made explicit wherever it exists, with `updates/release-types.feature` as the single model. Four surfaces found: the release-type vocabulary itself, the update channel, the integrity compatibility daemon, and the signing keys. |
| Call recording | Unconditional. LineageOS ships the same dialer with it off and the microphone as source; /e/OS ships it on with the voice-call source. Verified in the tree. |
| microG hiding — who owns the list | microG itself (`e/os/GmsCore`). The user-facing half is specified there. |
| Android Auto | Relaxation stated explicitly, with the alternatives that were available written out in the file's header. |

## Checked against the Android 16 porting epic

Cross-checked against https://gitlab.e.foundation/groups/e/os/-/work_items/211.
Added as a result: `process/fork-maintenance.feature`,
`apps/browser-and-webview.feature`, the Firebase/IMS scenarios in
`privacy/degoogled-defaults.feature`, the recovery-update rule in
`device/recovery.feature`, the Blueprint scenario in
`apps/prebuilt-maintenance.feature`, and the per-component signing scenario in
`updates/release-types.feature`.

Epic items that are **not** specified here, and why:

| Epic item | Status |
|---|---|
| `android_build` (build/make) | The fork was dropped; /e/OS uses LineageOS's `build/make`. Nothing to specify. Recorded in `COVERAGE.md`. |
| Build from pipelines, signing script, generated signatures, a16 branches | Build infrastructure that lives outside this tree. The parts with an observable consequence in the tree are specified: the branch model and the upstream merge in `process/fork-maintenance.feature`, the signing outcome in `updates/release-types.feature`. |
| Upstream dashboard (e/os/backlog#3600) | Still open upstream; nothing in the tree to specify yet. |
| Weblate for the forked projects (e/os/backlog#2955) | Still open upstream. Several files assert that /e/OS-specific strings are translated; the translation *process* is not specified because it is not in place. |
| Community devices from LineageOS (e/os/backlog#3725) | Device trees are not in this manifest — only the generic and AOSP ones. The device catalogue lives elsewhere. |
| UI updates for clock, calculator, glimpse, recorder, twelve | Prebuilt applications; out of scope by agreement. Their theming is covered at the system level by `apps/application-icons-and-theme.feature`. |

## Found by sweeping the resource overlays

Behaviour that lives only in a resource overlay has no commit message
describing it, so it does not show up when reading history. A sweep of
`vendor/eos/overlay`, `vendor/lineage/overlay`, `packages/overlays/Lineage` and
`external/prebuiltapks/**/rro_overlays` produced
`apps/default-app-associations.feature`: the autofill and credential provider
roles, the system gallery role, the QR code handler, the calendar and clock
dynamic icon targets, the launcher kept on managed devices, the splash screen
exceptions, the maps application's naming, and the strings /e/OS supplies for
Qualcomm vendor components. The Android Auto automotive-projection and
companion-device pinning, and the lock screen wallet shortcut, came from the
same sweep.

A second sweep, of the configuration files, found two more surfaces:

- `GmsCore/microg.xml` — the default microG configuration /e/OS ships. This is
  the single most consequential undocumented file in the tree: it decides that
  cloud messaging, device check-in and Google network access are on by default,
  that location resolves against an open database instead, and that store
  features such as billing and licensing work. Now
  `compatibility/microg-configuration.feature`.
- The 19 privileged-permission allowlists, power-save and hidden-API
  allowances, and the per-user-type installation declarations. Now rules in
  `apps/default-permissions.feature`.

Worth repeating on the next pass: an overlay or a configuration file can change
behaviour silently, and no amount of commit reading finds it. The surfaces to
sweep are `**/rro_overlays`, `overlay/`, `privapp-permissions-*`,
`permissions_*`, `allowlist_*`, `whitelist_*`, `default-permissions_*`,
`preinstalled-packages-*`, `initial-package-stopped-states-*`, and any XML that
is a settings map rather than a resource.

## Surfaces swept, and what is left

| Surface | Swept | Result |
|---|---|---|
| Commit history of all 84 forks vs LineageOS | yes | the bulk of the specification |
| Release-type branching (`RELEASE_TYPE`, `LINEAGE_BUILDTYPE`, `ro.lineage.releasetype`) | yes | 4 surfaces, `updates/release-types.feature` |
| Android 16 porting epic | yes | 6 gaps filled, 2 items no longer applicable |
| Resource overlays (RRO and overlaid `config.xml`) | yes | `apps/default-app-associations.feature` |
| Configuration files (permission allowlists, microG defaults, user types) | yes | `compatibility/microg-configuration.feature`, rules in `apps/default-permissions.feature` |
| Product makefiles and system properties | yes | nothing further; the behavioural ones were already specified |
| SELinux policy | yes | folded into `apps/default-permissions.feature` |
| `default.xml` vs LineageOS's | yes | identical project list; /e/OS removes nothing extra |
| Translations (`values-*`) | no | deliberate; Weblate is not in place (see above) |
| Device trees and kernel | no | outside this manifest |
| Prebuilt application internals | no | out of scope by agreement |

## Still open

1. **`ih8sn` gating — still the one to confirm.** The makefile reads: a `user`
   build never ships the daemon (the `?=` on the user-variant branch wins), and
   a non-`user` build ships it when the release type is official, community or
   partner. So an official release cut as a `user` build does **not** carry it,
   which makes the daemon community-only in practice. The specification states
   the rule as implemented, in `updates/release-types.feature` and
   `compatibility/play-integrity-compat.feature`. Confirm the intent matches —
   the two readings differ for official releases.

2. **Fake location without Advanced Privacy.** Left explicitly unspecified in
   `privacy/fake-location.feature`. If Advanced Privacy is removed, the code
   falls through to the real location. Is that the behaviour you want to commit
   to, or should the feature be considered unavailable? Worth deciding before
   someone relies on the fall-through.

3. **`hardware/qcom-caf/thermal`** is forked on `a16` but not on `v4.3-a16`, so
   it is not covered by this pass. Does it carry behaviour worth specifying?

4. **Where these files live long term.** They are in the manifest repository,
   which is the only place that sees the whole product. If the per-application
   specifications land in the application repositories, is there an index to
   build, or does `COVERAGE.md` stay the index?

5. **Review cadence.** These specifications will drift the moment a fork gains
   a commit. Is it worth a CI job on this repository that re-runs the diff and
   flags projects whose delta changed since the last pass?
