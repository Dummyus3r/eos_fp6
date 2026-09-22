# Open questions

## Recorded, not decided

| Question | Where it shows up |
|---|---|
| Is the OTA update check's anonymous install counter (random ID, reset on factory reset, no user-facing information or opt-out today) compatible with GDPR / the CNIL audience-measurement exemption? | `privacy/no-telemetry-without-consent.feature` |
| Which `features/` files, if any, should be added as citations for the security, sustainability, and localization/form-factor/dark-mode requirements once they are broken down into concrete specs? | `security/*.feature`, `sustainability/*.feature`, `localization/*.feature`, `form-factor/*.feature`, `dark-mode/*.feature` |
| A coverage-report tool (on the model of `features/tools/gen-by-repository.py`) that lists requirements with no citing `features/` file does not exist yet. | `requirements/README.md` |

## Decided here, not yet closed in GitLab

| Question | Decision | GitLab ticket |
|---|---|---|
| Support duration for community devices with no newer Android version available | Same as the general Android-version support rule: OTA updates for as long as /e/OS supports that version. | e/devices/backlog#2036 (still open) |
| Support policy for community devices with a newer Android version available | The new version is made available; the old one's builds stop after a transition period. | e/devices/backlog#2037 (still open) |
