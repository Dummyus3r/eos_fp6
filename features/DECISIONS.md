# First-pass review record

## Decisions taken

Recorded here so the next pass does not re-litigate them.

| Question | Decision |
|---|---|
| Language | English. |
| Reference branch | `v4.3-a16`. The `a16` development manifest forks fewer projects; the extra forks on `v4.3-a16` exist to carry the monthly security patch. |
| Executable or documentary | Documentary for now. |
| Version tagging per feature | No. Traced through the manifest instead, which gives the version when it is needed. |
| One scenario per CVE | No. One file for the security-patch policy. |
| Prebuilt boundary | System-side contract here, behaviour in the application repository, `@prebuilt-boundary` on the boundary. |
| `frameworks/libs/systemui` badges | Stay here, as a platform contract, not in the BlissLauncher3 repository. |
| Partner hardware enablement | In scope. `device/hardware-support.feature`. |
| Theming | One file for everything theme-related. |
| Reverted work | Describe the tree as it stands, after the revert. |
| Telemetry in developer options | Deliberate. |
| Flashing scripts | In scope — users flashing by hand depend on them. `device/flashing-package.feature`. |
| Prebuilt update policy | Manual, by hand. `apps/prebuilt-maintenance.feature`. |
| `packages/apps/TV`, `TvSettings`, `Car/Settings` | Nothing on the /e/OS side. Not specified. |
| Release-type-dependent behaviour | Explicit wherever it exists, `updates/release-types.feature` as the single model. Four surfaces: the vocabulary itself, the update channel, the integrity compatibility daemon, the signing keys. |
| Call recording | Unconditional, verified in the tree — LineageOS ships it off, /e/OS on. |
| microG hiding — who owns the list | microG itself (`e/os/GmsCore`); the user-facing half is specified there. |
| Android Auto | Relaxation stated explicitly, alternatives written out in the file's header. |
| `ih8sn` gating for an official `user` build | Deliberate: community-only in practice, as implemented. |
| Fake location without Advanced Privacy | Moot — it's a system app, cannot be uninstalled. |
| Where these files live long term | `COVERAGE.md`, in this repository, stays the index for now. |
| Review cadence (CI drift check) | Needed eventually, deferred for now. |
| `hardware/qcom-caf/thermal` (forked on `a16`, missed by this pass's `v4.3-a16` diff) | Worth specifying — commit `4026baa9b2` relaxes the "volcano" platform's skin-temperature thresholds, fixing e/os/backlog#4622 (App Lounge refusing installs on a device that wasn't hot). Added to `device/hardware-support.feature`. |

## Checked against the Android 16 porting epic

Cross-checked against https://gitlab.e.foundation/groups/e/os/-/work_items/211.
Added: `process/fork-maintenance.feature`, `apps/browser-and-webview.feature`,
the Firebase/IMS scenarios in `privacy/degoogled-defaults.feature`, the
recovery-update rule in `device/recovery.feature`, the Blueprint scenario in
`apps/prebuilt-maintenance.feature`, the per-component signing scenario in
`updates/release-types.feature`.

Epic items **not** specified here, and why:

| Epic item | Why not |
|---|---|
| `android_build` (build/make) | Fork dropped; /e/OS uses LineageOS's as-is. |
| Build from pipelines, signing script, generated signatures, a16 branches | Infra outside this tree; its observable consequences are specified (`process/fork-maintenance.feature`, `updates/release-types.feature`). |
| Upstream dashboard (e/os/backlog#3600) | Still open upstream. |
| Weblate for the forked projects (e/os/backlog#2955) | Still open upstream; strings assert translation, the process doesn't exist yet to specify. |
| Community devices from LineageOS (e/os/backlog#3725) | Device trees aren't in this manifest. |
| UI updates for clock, calculator, glimpse, recorder, twelve | Prebuilt apps, out of scope; theming covered at the system level (`apps/application-icons-and-theme.feature`). |

## Found by sweeping, not by reading commits

An overlay or a bare config file changes behaviour with no commit message
describing it — reading history alone misses it. Sweeping
`vendor/eos/overlay`, `vendor/lineage/overlay`, `packages/overlays/Lineage`,
`external/prebuiltapks/**/rro_overlays` produced
`apps/default-app-associations.feature` in full: autofill/credential
provider roles, the system gallery role, the QR handler, calendar/clock
dynamic icons, the launcher kept on managed devices, splash-screen
exceptions, the maps app's naming, Qualcomm vendor-component strings,
Android Auto's projection/pinning, the lock-screen wallet shortcut.

A second sweep, of configuration files, found:

- `GmsCore/microg.xml` — the single most consequential undocumented file in
  the tree (cloud messaging, check-in, Google network access, location
  backend, store features, all decided here). Now
  `compatibility/microg-configuration.feature`.
- 19 privileged-permission allowlists, power-save/hidden-API allowances,
  per-user-type installs. Now rules in `apps/default-permissions.feature`.

Next pass, sweep again: `**/rro_overlays`, `overlay/`, `privapp-permissions-*`,
`permissions_*`, `allowlist_*`, `whitelist_*`, `default-permissions_*`,
`preinstalled-packages-*`, `initial-package-stopped-states-*`, and any XML
that's a settings map rather than a resource.

## Surfaces swept, and what's left

| Surface | Swept | Result |
|---|---|---|
| Commit history of all 84 forks vs LineageOS | yes | the bulk of the specification |
| Release-type branching | yes | 4 surfaces, `updates/release-types.feature` |
| Android 16 porting epic | yes | 6 gaps filled, 2 items no longer applicable |
| Resource overlays | yes | `apps/default-app-associations.feature` |
| Configuration files | yes | `compatibility/microg-configuration.feature`, rules in `apps/default-permissions.feature` |
| Product makefiles and system properties | yes | nothing further |
| SELinux policy | yes | folded into `apps/default-permissions.feature` |
| `default.xml` vs LineageOS's | yes | identical project list |
| Translations (`values-*`) | no | deliberate; Weblate not in place |
| Device trees and kernel | no | outside this manifest |
| Prebuilt application internals | no | out of scope by agreement |
