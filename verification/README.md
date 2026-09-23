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
@scenario("features/branding/identity.feature::The build identifies itself as /e/OS")
def test_build_identifies_as_eos(a17):
    assert re.match(r"^\d+\.\d+-a17-", prop("ro.lineage.version", a17))
```

Nothing else records the link — no mapping file to keep in sync, and no test
identifier injected into the specification, which stays a deliverable of its
own.

Scenario titles are **not unique** across the corpus (three collide today), so
the key is always `<path>::<title>`.

`verification/tools/gen-coverage.py` reads those markers and reports both
directions, because both are defects:

* a scenario no check names — the specification promises something nothing
  looks at;
* a check naming a scenario that no longer exists — the specification moved and
  the check quietly stopped meaning anything.

It exits non-zero on the second, so it runs as a CI gate and not only as a
report. It also refuses a marker that is not a plain string literal: extraction
is static, and an f-string would understate coverage instead of failing.

## Comparing against the previous generation

Several checks take both an `a17` device and an `a16` one. Where the promise is
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
    --a17 emulator-5556 \
    --a16 emulator-5554 \
    --product-out out/target/product/emu64x
```

Checks whose fixtures are not supplied skip rather than fail, so the artefact
pass runs without a device and the device pass runs without a reference.

## Layout

```
verification/
├── tools/probes.py          read-only probes: adb, and the built image
├── tools/gen-coverage.py    generates COVERAGE.md, gates on orphaned checks
├── checks/conftest.py       the @scenario marker and the device fixtures
├── checks/test_*.py         the checks themselves
└── journeys/                the flow model, and the flows
```
