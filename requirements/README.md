# Product requirements

This folder holds product-level **requirements**: promises /e/OS makes that
must hold regardless of which commit is being reviewed, written **top-down**
by a human, independently of any single feature or issue.

## How this differs from `features/`

`features/` is descriptive and **bottom-up**: it captures what the code does
today, derived by diffing /e/OS against LineageOS. It answers "what has been
built and specified so far?" — it has no way to say "what is not yet covered",
because the list of what *should* exist only exists as the sum of what has
been done.

`requirements/` is normative and **top-down**: each file states a promise
that must always hold, written before — and independently of — any code that
proves it. A requirement can (and, for a new one, will) exist with no
scenario proving it yet; that gap is the point — it is what a coverage
report can flag, which a purely bottom-up `features/` folder cannot.

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
