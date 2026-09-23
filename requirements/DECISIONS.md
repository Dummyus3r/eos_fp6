# First-pass review record

## Decisions taken

Recorded here so the next pass does not re-litigate them.

| Question | Decision |
|---|---|
| "Granular permission control" as its own promise | Dropped — not the original intent. Reused for `pre-granted-permissions.feature` instead: default apps get their permissions pre-granted to smooth first use, and the user can always revoke them. A genuine "fine-grained control per data type" promise would need its own grounding (e.g. Advanced Privacy) if wanted later. |
| Push registration and "no Google contact by default" | Split into two rules: the system's own IMS-entitlement Firebase registration (carrier-gated, unrelated to third-party apps) and a separate rule for third-party apps (microG registers a push-requesting app only because that app asked — verified against `e/os/GmsCore`'s `PushRegisterService.kt`/`GcmPrefs.kt`). |
| Location resolution vs. "no Google contact by default" | Merged into one promise — both are facets of the same guarantee, even though `features/` keeps them in separate files for source-mapping reasons. |
| OTA update check's anonymous install counter | Known exception to "no telemetry without consent", not covered by that promise until the GDPR/audience-measurement question is resolved — recorded inline in `privacy/no-telemetry-without-consent.feature`, not duplicated here. |
| Android-version support duration for official devices | Beyond the EU legal minimum, as far as technically possible, delivered via OTA update. |
| Community devices without a newer Android version | Same duration as the general Android-version support rule — OTA updates for as long as /e/OS supports that version, no separate community cutoff. |
| Community devices with a newer Android version available | The new version is made available (no OTA version-upgrade — migration stays manual); the previous version's builds stop after a transition period. |

## The promise is the citable unit, not its scenarios

A requirement file holds one `Feature:` — the promise — and scenarios that
illustrate facets of it. The identifier goes on the promise: "this merge request
serves P6" is what someone writes, and citing a facet would say less than citing
what it is a facet of.

Numbering is flat, `@P-n`, not prefixed per area. There are sixteen promises; a
short number is easier to say out loud, and the areas are already visible in the
folder.

## Citations move from paths to identifiers, gradually

`# Proven by:` originally named `features/` files. A file holds many scenarios
and usually only some of them prove the promise, so the path says less than it
appears to — and it breaks when the file is renamed.

Citing scenarios by identifier fixes both. Converting the existing citations is
editorial work, though: it takes deciding which scenarios actually prove a
promise, which is a judgement, not a transformation. So the generator accepts
both forms and reports the ones still at file granularity rather than guessing
at the narrowing.
