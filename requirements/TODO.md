# Open questions

## Recorded, not decided

| Question | Where it shows up |
|---|---|
| Is the OTA update check's anonymous install counter (random ID, reset on factory reset, no user-facing information or opt-out today) compatible with GDPR / the CNIL audience-measurement exemption? | `privacy/no-telemetry-without-consent.feature` |
| Which `features/` files, if any, should be added as citations for the security, sustainability, and localization/form-factor/dark-mode requirements once they are broken down into concrete specs? | `security/*.feature`, `sustainability/*.feature`, `localization/*.feature`, `form-factor/*.feature`, `dark-mode/*.feature` |
| A coverage-report tool (on the model of `features/tools/gen-by-repository.py`) that lists requirements with no citing `features/` file does not exist yet. | `requirements/README.md` |
| Support duration for community devices with no newer Android version available — open decision, e/devices/backlog#2036. | `sustainability/android-version-longevity.feature` |
| Support policy for community devices with a newer Android version available — open decision, e/devices/backlog#2037. | `sustainability/android-version-longevity.feature` |
