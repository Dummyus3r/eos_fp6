# Product requirements

This folder holds product-level **requirements**: promises /e/OS makes that
must hold regardless of which commit is being reviewed, written **top-down**
by a human, independently of any single feature or issue — checked against
[`features/`](../features/README.md), not derived from it.

## Convention

* One `Feature:` per file, one promise per feature; `Rule:` groups scenarios
  that illustrate the same facet of it, same as in `features/`.
* Each file opens with a `# Proven by:` comment listing the `features/*.feature`
  files whose scenarios currently prove this requirement, or `# Proven by:
  (none yet)` when nothing does. This is a citation, not a duplication —
  the executable detail stays in `features/`; a requirement file states the
  promise and points at what proves it. `requirements/tools/gen-coverage.py`
  parses this line, so keep it to a bare, comma-separated list of paths — put
  any explanation (e.g. a related-but-not-proving file) on a separate
  `# Related, not proving:` line instead, never inside the `# Proven by:`
  block itself.
* A requirement with no scenario at all is valid: it means the promise is
  declared but not yet broken down into testable behaviour. It should read
  as a gap to close, not be quietly dropped.

## Layout

```
requirements/
├── privacy/            no Google contact, no telemetry, tracker blocking, location
├── security/           monthly patches, backport to older Android versions
├── sustainability/     Android version longevity
├── user-experience/     default apps, Workspace account, permissions, UI/UX,
│                       Google/Yahoo account integration, Android app
│                       compatibility, carrier/operator functionality
├── localization/       supported languages
├── form-factor/        smartphone and tablet support
└── dark-mode/          system-wide dark theme
```

## Status

First pass. Privacy is grounded in existing `features/` content (see each
file's `# Proven by:` line); every other pillar is declared but not yet
proven — no `features/` file specifies them yet. Run
`python3 requirements/tools/gen-coverage.py` to regenerate `COVERAGE.md`,
which lists every requirement as proven, not yet proven, or citing a
`features/` file that does not exist.
