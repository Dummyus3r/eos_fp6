# /e/OS feature specifications

This folder holds executable-style specifications (Gherkin / Cucumber)
describing **what /e/OS adds on top of LineageOS** — /e/OS forks ~85
projects, and the commit history was the only record of that delta until
this folder existed.

## Scope

**In scope** — behaviour that differs between a LineageOS build and an /e/OS
build of the same Android version, coming from projects forked under the `e`
remote (see `snippets/eos.xml`).

**Out of scope, on purpose**

| Excluded | Why |
|---|---|
| Prebuilt applications (App Lounge, Advanced Privacy, eDrive, Mail, Calendar, Camera, Browser, Notes, Tasks, Parental Control, Find My Device, …) | Each has its own repository; only their *system-side integration* is described here. |
| BlissLauncher3 | Own repository, own specification; only the system hooks it needs are described here. |
| Android Security Bulletin backports | Individual CVE fixes are upstream AOSP work; the *policy* of shipping them is `updates/`. |
| CI / licensing / translation-import commits | Not user-facing, but the machinery keeping ~85 forks merged with LineageOS is specified in `process/fork-maintenance.feature`. |

## Convention

* One `Feature:` per file, at the repository root as `features/` — the
  convention every Gherkin tool (Cucumber, cucumber-js, behave, godog) looks
  for by default.
* Concrete values, not adjectives: a colour is `#0086FF`, not "the /e/OS
  palette" — the first is testable, the second isn't.
* Release-type-dependent behaviour points at `updates/release-types.feature`,
  the single place that model is specified, rather than restating it.
* Tags name the upstream project(s), e.g. `@frameworks-base`, `@vendor-eos`;
  `@device-specific`, `@optional`, and `@prebuilt-boundary` mark real
  exceptions — see them in context for what each means.
* Each file's header comment lists the /e/OS commits its scenarios were
  derived from, so the spec can be re-checked against the code.

## Layout

```
features/
├── branding/        visual & textual identity
├── privacy/         tracker blocking, location, microG hiding, telemetry
├── identity/        Murena Workspace account integration
├── setup/           first-time wizard
├── updates/         release types, OTA and security-patch policy
├── compatibility/   microG, SafetyNet/Play Integrity, Android Auto, app links
├── apps/            preinstalled app set, permissions, role assignments
├── connectivity/    DNS, APN, telephony defaults
├── system/          settings tree, system UI, parental control enforcement
├── device/          recovery, hardware support, the flashing package
├── process/         how the fork itself is kept current
└── tools/           the generator for BY-REPOSITORY.md
```

## Status

First pass, derived by diffing every project of `snippets/eos.xml` (reference:
the `v4.3-a16` manifest) against its LineageOS counterpart. `COVERAGE.md` maps
every forked project to the file that specifies it; `TODO.md` records the
decisions taken and the questions still open.
