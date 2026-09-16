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
| Call recording | Unconditional. LineageOS ships the same dialer with it off and the microphone as source; /e/OS ships it on with the voice-call source. Verified in the tree. |
| microG hiding — who owns the list | microG itself (`e/os/GmsCore`). The user-facing half is specified there. |
| Android Auto | Relaxation stated explicitly, with the alternatives that were available written out in the file's header. |

## Still open

1. **`ih8sn` gating.** The makefile reads: a `user` build never ships the
   daemon (the `?=` on the user-variant branch wins), and a non-`user` build
   ships it when the release type is official, community or partner. That means
   an official build shipped as a `user` build does **not** carry it. Is that
   the intent — i.e. is the daemon effectively community-only in practice? The
   spec states the rule as the makefile implements it; confirm the intent
   matches, because the two readings differ for official releases.

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
