# Decisions taken while writing this

Recorded so the next person does not have to re-derive them, and can overturn
them knowing what they cost.

## pytest and a marker, not a bespoke format

A small declarative format was drafted first — `[file::scenario]` followed by
`prop … matches …` lines. It reads well and it was the wrong call: it means
writing a parser, documenting a grammar, and rebuilding selection, reporting,
parallelism and CI output that pytest already has. A marker is one line of
`conftest.py`, and anything a grammar would have made awkward stays ordinary
Python.

## The link lives in the check, not in the specification

The alternative — tagging each scenario in `features/` with a test identifier —
pollutes a file that is a deliverable in its own right, and couples the
specification to the current shape of the harness. A third mapping file was
rejected for the usual reason: two things that must agree will eventually not.

The cost of this choice is that a scenario rename silently orphans a check, so
the generator reports orphans and exits non-zero on them.

## Keys are `<path>::<title>`, never the title alone

Three scenario titles collide across the corpus today. The path is not
decoration.

## Comparison against a16 where the promise is a delta

Several checks assert both a literal and equality with the a16 device. The
literal alone would pass on a build where the /e/OS configuration never applied
but the same default happened to be inherited from upstream; the comparison
alone would pass if both generations lost it together. Together they state what
the scenario actually promises.

## Journeys are walks, not independent tests

A flow is stateful and ordered. Modelling its steps as independent tests would
mean replaying the whole wizard for each one, and would still not express "this
step was never reached" — which is the failure worth catching. So a journey
records the sequence it traversed, and that sequence is the assertion.

This came from a real defect: three setup wizard pages were wired behind a step
nothing reaches, because upstream had commented out the step that led to it.
They compiled, they read correctly in the wizard script, and they were never
shown. No unit test and no review caught it.

## Fixtures are roles, not generations

The first version named them `a17` and `a16`. Putting the older build under test
then read as `a17 = <the a16 device>`, and every check would have needed
rewriting at the next generation. `device` / `reference` / `lineage` say what
each one is for.

## A negative control, separate from the reference

Running the a17 checks against the a16 build was tried as a way of measuring
whether they discriminate. It does not work: a16 is /e/OS too, so a check
passing on both says nothing — and the experiment reported perfectly good
checks as weak. The control has to be a LineageOS build, and
`tools/negative-control.py` refuses a device carrying /e/OS content so that
mistake cannot be made silently.

This costs something real: it means keeping a LineageOS image of the generation
around. `lineage-24-pinned.xml` records the tree a17 was cut from, which is what
that image would be rebuilt from.

## No screenshot comparison

Tried in principle, rejected on the hardware: the emulator renders through
SwiftShader without a GPU, so its output does not match a device's, and font
rendering drifts between builds. A pixel diff here is a false-positive factory.
Where the promise is visual, assert the resolved resource value instead, and
keep captures as review material rather than as assertions.

## Not every scenario gets a check, and that is recorded

Some scenarios state a promise about the porting process rather than about the
device. Rather than contort them into something executable, or drop them,
`COVERAGE.md` lists them as unverified.

## The key is the scenario identifier

The first version keyed on `<path>::<title>`. Both halves invite editing, and
three titles already collide across the corpus, so the key moved to the
permanent identifier `features/` now carries. The report shows the title
alongside it, so a JUnit report stays readable without opening the
specification, but the link itself is the number.

## Only a measurement on the running application counts as proven

Raised in review of !210: a patch can be green at compile time and have no
effect at runtime, so what proves a scenario is playing it on the running
application, not a test that reads the build.

Taken as written. `@evidence(...)` records the level, and COVERAGE.md counts
only `measured` as proven. The immediate effect is that the headline figure
drops from 12 to 0, which is the honest number: everything written so far
queries a booted system without playing a scenario.

The weaker levels are kept rather than deleted. Reading the built image catches
a whole class of regression in seconds, well before an emulator has booted —
it is good feedback. It just is not proof, and the report says which is which
instead of adding them together.
