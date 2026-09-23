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

## The requirement is the citable unit, not its scenarios

A requirement file holds one `Feature:` and scenarios that illustrate facets of
it. The identifier goes on the `Feature:`: "this merge request serves R6" is
what someone writes, and citing a facet would say less than citing what it is a
facet of.

Numbering is flat, `@R-n`, where `features/` prefixes by area. The reason is
not that there are only sixteen — that argument ages badly, and it would apply
to `features/` too. It is that the two corpora are cited side by side: a
`# Proven by:` line puts scenario identifiers under a requirement, and a merge
request writes "serves R6, proven by PRIV-33". Prefixing requirements by area
would put `privacy` on both sides of that sentence — `@PRIV-3` could be either,
and `@RPRIV-3` differs from `@PRIV-3` by one character, which is a source of
error rather than a help. A flat `@R-n` is recognisable at a glance.

The trade-off is that a requirement number carries no hint of where it lives.
That is affordable at this size and would stop being so somewhere past fifty
requirements — at which point it could no longer be changed, since the numbers
would be cited. If the register ever approaches that, the question to settle is
not the prefix but whether `requirements/` has become a second `features/`.

## One word for one thing: requirement, not promise

The first version of this called them promises — `@P-n`, `PROMISES.md` — taking
the word from a line of this README that describes requirements as "promises
/e/OS makes". That reads well as prose and was wrong as structure: the folder,
the register and the coverage report all say *requirement*, so a reader opening
`PROMISES.md` inside `requirements/` has to work out they are the same thing.
Renamed before anything cited the identifiers, which is the only moment it was
free to do.

## Citations move from paths to identifiers, gradually

`# Proven by:` originally named `features/` files. A file holds many scenarios
and usually only some of them prove the requirement, so the path says less than it
appears to — and it breaks when the file is renamed.

Citing scenarios by identifier fixes both. Converting the existing citations is
editorial work, though: it takes deciding which scenarios actually prove a
requirement, which is a judgement, not a transformation. So the generator accepts
both forms and reports the ones still at file granularity rather than guessing
at the narrowing.
