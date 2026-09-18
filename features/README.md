# /e/OS feature specifications

This folder holds executable-style specifications (Gherkin / Cucumber) describing
**what /e/OS adds on top of LineageOS**.

## Why

/e/OS is a fork of LineageOS. Most of the source tree is identical; the value
/e/OS brings lives in a few hundred commits spread across ~85 forked projects.
Those commits are the only place the behaviour is documented today, which makes
it hard to answer "what does /e/OS actually do differently?" without reading git
history.

These `.feature` files capture that behaviour in a human-readable, testable form.

## Scope

**In scope** — behaviour that differs between a LineageOS build and an /e/OS
build of the same Android version, coming from projects forked under the `e`
remote (see `snippets/eos.xml`).

**Out of scope, on purpose**

| Excluded | Why |
|---|---|
| Prebuilt applications (App Lounge, Advanced Privacy, /e/ Drive, Mail, Calendar, Camera, Browser, Notes, Tasks, Parental Control, Find My Device, …) | Each has its own repository; their features will be specified there. Only the *system-side integration* of those apps is described here. |
| BlissLauncher3 (`packages/apps/Launcher3` → `e/os/BlissLauncher3`) | Own repository, own specification. Only the system hooks it needs are described here. |
| Android Security Bulletin backports | /e/OS carries ASB patches ahead of LineageOS, but the individual CVE fixes are upstream AOSP work, not /e/OS features. The *policy* of shipping them is specified in `updates/`. |
| CI / licensing / translation-import commits | Not user-facing behaviour — but the *machinery* that keeps ~85 forks merged with LineageOS is a deliverable in its own right, and is specified in `process/fork-maintenance.feature`. |

## Layout

```
features/
├── branding/        visual & textual identity
├── privacy/         tracker blocking, location, microG hiding, telemetry
├── identity/        /e/ account integration
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

## Why `features/` and not `.features/`

`features/` at the repository root is the convention every Gherkin tool uses —
Cucumber, cucumber-js, behave and godog all look there by default, and
Cucumber-JVM keeps the name under `src/test/resources/`. A dot-prefixed
directory is reserved for tooling configuration (`.github/`, `.gitlab/`), and
these files are content, not configuration. They should also be easy to find:
the first review of this folder reported behaviour as missing that was in fact
specified, simply because it was not where a reader looked.

## Conventions

* One `Feature:` per file.
* Where a behaviour has a concrete value — a colour, a URL, a hostname, a sound —
  the specification names it. "Follows the /e/OS palette" is not testable;
  `#0086FF` is.
* Behaviour that depends on the release type (official, community, partner,
  test, unofficial) says so explicitly, and points at
  `updates/release-types.feature`, which is the single place the release-type
  model is specified.
* Tags name the upstream project(s) the behaviour lives in, e.g.
  `@frameworks-base`, `@settings`, `@vendor-eos`.
* **`@device-specific`** marks a feature whose scenarios apply only to the
  devices they name. Carrying one to a new Android version is a decision taken
  per item and per device, not an automatic consequence of the port.
* **`@optional`** marks a feature whose content depends on the build — build
  variant, release type, minimal build, telephony or not.
* `@prebuilt-boundary` marks a scenario whose *other half* is implemented in a
  prebuilt app repository — the scenario only asserts the system-side contract.
* Comment blocks at the top of each file list the /e/OS commits the scenarios
  were derived from, so the spec can be re-checked against the code.

## Status

First pass, derived by diffing every project of `snippets/eos.xml` (reference:
the `v4.3-a16` manifest) against its LineageOS counterpart. `COVERAGE.md` maps
every forked project to the file that specifies it; `TODO.md` records the
decisions taken and the questions still open.
