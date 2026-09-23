# Verification

This folder holds the **checks**: what actually looks at a build and decides
whether [`features/`](../features/README.md) is satisfied. `features/` states
what /e/OS adds over LineageOS; this states how we know it is still true.

## Three passes, by cost

| Pass | Needs | Covers | Time |
|---|---|---|---|
| artefact | a built image, nothing running | properties, package set, pre-granted permissions, resource values | seconds |
| device | a booted device | effective permission grants, default roles, settings | minutes |
| journey | a booted device, driven | flows: the setup wizard, a tour of the settings | minutes per journey |

Prefer the cheapest pass that can answer. An artefact probe runs right after a
build, needs no boot, and cannot be perturbed by state a previous run left
behind.

## How a check names what it verifies

The link lives in the check, as a marker:

```python
@delta
@evidence("observed")
@scenario("@BRAND-2")
def test_build_identifies_as_eos(device):
    assert re.match(r"^\d+\.\d+.*-a17-", prop("ro.lineage.version", device))
```

The identifier, not a path and a title: it survives the scenario being renamed
or moved, which a path does not, and three scenario titles collide across the
corpus.

Nothing else records the link — no mapping file to keep in sync, and no test
identifier injected into the specification, which stays a deliverable of its
own.

## Checked is not proven

`@evidence(...)` says how strongly a check proves its scenario:

| level | meaning |
|---|---|
| `measured` | the scenario was played on the running application |
| `observed` | the running system was queried, the scenario was not played |
| `inspected` | the build was read, nothing ran |

**Only `measured` counts as proven.** A patch can be green at build time and
have no effect at runtime, and that is exactly what the weaker levels miss:
reading `ro.config.ringtone` says the value is in the image, not that a ringtone
plays. The weaker levels are useful feedback and they are kept, counted apart
rather than folded into one number — a coverage figure that mixes them says less
than it appears to.

Today that means **0 of 344 proven** and 12 checked: everything written so far
queries a booted system without playing a scenario. The journeys are what will
move scenarios into `measured`.

`verification/tools/gen-coverage.py` reads those markers and reports both
directions, because both are defects:

* a scenario no check names — the specification promises something nothing
  looks at;
* a check naming a scenario that no longer exists — the specification moved and
  the check quietly stopped meaning anything.

It exits non-zero on the second, so it runs as a CI gate and not only as a
report. It also refuses a marker that is not a plain string literal: extraction
is static, and an f-string would understate coverage instead of failing.

## Three roles, not three generations

Devices are addressed by role — `device` for the build under test, `reference`
for a previous /e/OS build, `lineage` for the negative control. Naming them
after roles rather than after a16/a17 is deliberate: the suite has to survive
the next generation without being rewritten, and a run putting the older build
under test should not read as `a17 = <the a16 device>`.

## The negative control

A check marked `@delta` asserts /e/OS content, so it must **fail** on a build
with no /e/OS content. One that passes there is asserting something Android or
LineageOS satisfies on its own: it will keep passing after the /e/OS change it
claims to verify has been lost, which is precisely what a verification suite
exists to prevent.

```
python3 verification/tools/negative-control.py <lineage serial>
```

The reference build cannot play this role — it is /e/OS too, so a check passing
on both says nothing about it. The tool refuses a device carrying `foundation.e`
packages or `ro.elegal.url`, because being handed a reference instead of a
control would produce a report reading as "this suite asserts nothing".

## Comparing against a previous build

Several checks take both a `device` and a `reference`. Where the promise is
"/e/OS decides this, not LineageOS", comparing against the previous generation
states it better than a literal: `== "Selenium.ogg"` keeps passing while meaning
nothing the day the chosen sound changes.

This is also how a journey earns its keep — the same walk on both devices turns
into a diff of the steps traversed. A step a16 shows and a17 does not is either
an upstream restructuring or an /e/OS step lost in the port.

The caveat is that a16 is Android 16 and a17 is Android 17, so a raw comparison
mixes what the port lost with what upstream changed on its own. On properties
the noise is small and filterable; on pixels it is overwhelming, which is why
nothing here compares images.

## What is deliberately not here

**No Gherkin runner.** Only scenario *titles* are parsed, never the prose of the
steps. The prose is varied by design — it is a specification written for people
— and wiring a step definition for each sentence is a cost that never stops.

**No screenshot comparison.** The emulator renders through SwiftShader with no
GPU; its pixels do not match a device's, and font rendering drifts. Where the
promise is visual, compare the resolved resource — the accent colour, the
drawable — and keep captures for the handful of cases where only an eye will do.

**Not every scenario is verifiable here.** Some state a promise about how the
port is carried out rather than about the device — "the /e/OS changes are
brought in on top through merge requests" has no device-level evidence at all.
`COVERAGE.md` lists them as unverified so the choice stays visible instead of
being quietly dropped.

## Running

```
python3 verification/tools/gen-coverage.py           # report + CI gate, no device

pytest verification/checks \
    --device emulator-5556 \
    --reference emulator-5554 \
    --product-out out/target/product/emu64x

python3 verification/tools/negative-control.py emulator-5558   # a LineageOS build
```

Checks whose fixtures are not supplied skip rather than fail, so the artefact
pass runs without a device and the device pass runs without a reference.

## In CI

`verification/.gitlab-ci.yml` declares two jobs, because their requirements
differ sharply:

* **`verification:coverage`** needs nothing but Python. It regenerates the
  report and fails when a check names a scenario that no longer exists, or when
  `COVERAGE.md` is stale — the drift worth catching on every change to
  `features/`.
* **`verification:device`** needs a runner with a booted /e/OS emulator, so it
  is tagged and gated on the serial being set.

The device job publishes a JUnit report, which GitLab renders in the merge
request. Checks are reported under the **scenario they verify** rather than
under their Python function name, so what a reviewer reads there is the
sentence from the specification:

```
verification.checks.test_branding :: The build identifies itself as /e/OS
verification.checks.test_release_types :: An unofficial build can still be identified
```

## Layout

```
verification/
├── tools/probes.py          read-only probes: adb, and the built image
├── tools/gen-coverage.py    generates COVERAGE.md, gates on orphaned checks
├── tools/negative-control.py  runs the @delta checks against a LineageOS build
├── checks/conftest.py       the @scenario marker and the device fixtures
├── checks/test_*.py         the checks themselves
└── journeys/                the flow model, and the flows
```
