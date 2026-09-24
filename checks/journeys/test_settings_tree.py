"""Checks that walk the Settings tree.

Each one acts on the running application — taps an entry, types a search — and
asserts what the application then does. That is what makes them `measured`:
the same facts can often be read out of a package dump, but a dump cannot tell
whether the entry the user sees actually leads anywhere.
"""
from __future__ import annotations

import time

import pytest

import settings
import settings_tree
from conftest import delta, evidence, scenario
from probes import ui_dump


@scenario("@SYS-2")
@evidence("measured")
@delta
def test_advanced_privacy_entry_opens_the_dashboard(device):
    """Tapping the home page entry has to open Advanced Privacy itself.

    The entry is an /e/OS addition to the settings home page, and an entry that
    is present but wired to nothing would satisfy any check that only looks for
    the label.
    """
    opened = settings_tree.open_entry(device, "Advanced Privacy", expect="advancedprivacy")
    assert "foundation.e.advancedprivacy" in opened, (
        f"the Advanced Privacy entry opened {opened!r}")


@scenario("@SYS-3")
@evidence("measured")
@delta
def test_advanced_privacy_is_searchable(device):
    """Searching the settings for *privacy* has to offer Advanced Privacy.

    The result sits below the fold on a phone, so the results are scrolled to
    the bottom before concluding. Reading only the first screenful reports the
    entry as missing, which is a defect in the check and not in the build.
    """
    results = settings_tree.search(device, "privacy")
    assert any("Advanced Privacy" in r for r in results), (
        f"Advanced Privacy is not among the results: {results}")


@scenario("@SYS-20")
@evidence("measured")
@delta
def test_microg_entry_is_named_for_what_it_does(device):
    """microG is presented as *App compatibility*, and not under its own name.

    Both halves matter. The label is what /e/OS renamed; that searching for
    *microg* finds nothing is what makes the rename real rather than an alias
    sitting beside the old name.
    """
    assert any(r == "App compatibility" for r in settings_tree.search(device, "compatibility")), (
        "no 'App compatibility' entry in the settings search")
    assert "No results" in settings_tree.search(device, "microg"), (
        "the settings still offer an entry under the microG name")


@scenario("@PRIV-27")
@evidence("measured")
@delta
def test_no_statistics_entry_in_the_settings_tree(device):
    """The LineageOS statistics entry has to be gone from the settings.

    Searched rather than browsed: the settings search indexes the whole tree,
    so a negative result covers every screen, where walking the tree could only
    cover the screens the walk happens to visit.
    """
    results = settings_tree.search(device, "statistics")
    assert "No results" in results, (
        f"the settings still offer a statistics entry: {results}")


@scenario("@SYS-41")
@evidence("measured")
@delta
def test_no_suggestion_cards_on_the_home_page(device):
    """The AOSP contextual cards are not drawn on the settings home page.

    The assertion is on the container the cards are inflated into, not on their
    text: a card's wording is a translation away from changing, while the
    container is what /e/OS removed.
    """
    settings_tree.homepage(device)
    dump = ui_dump(device)
    assert "contextual_card" not in dump, (
        "the settings home page still inflates the contextual cards container")


@scenario("@NET-6")
@evidence("measured")
@delta
def test_private_dns_offers_quad9(device):
    """The one-tap provider is Quad9, and Cloudflare is gone.

    Both halves are needed. Offering Quad9 while leaving the LineageOS entry in
    place would satisfy a check that only looks for Quad9, and would leave the
    user a Cloudflare button — which is the thing /e/OS replaced.
    """
    entries = settings_tree.private_dns(device)
    assert any("Quad9" in e for e in entries), (
        f"no Quad9 provider in the private DNS dialog: {entries}")
    assert not any("Cloudflare" in e for e in entries), (
        f"a Cloudflare entry remains: {entries}")


@scenario("@PRIV-3")
@evidence("measured")
@delta
def test_selecting_quad9_sets_the_hostname(device):
    """Choosing the offered provider has to configure the resolver.

    The entry could read *Quad9* and set anything at all. What the scenario
    promises is the hostname the system ends up resolving through, so the
    check taps the entry and then reads what the system recorded — the
    application's effect, not its label.
    """
    from probes import _adb, setting
    before = {k: setting("global", k, device)
              for k in ("private_dns_specifier", "private_dns_mode")}
    settings_tree.private_dns(device)
    settings.enter(device, "Quad9 DNS")
    settings.enter(device, "Save")        # the dialog only commits on Save
    time.sleep(2.0)
    after = {k: setting("global", k, device) for k in before}
    for key, value in before.items():     # leave the device as it was found
        _adb(device, "shell", "settings", "put", "global", key, value or "null")
    assert after["private_dns_specifier"] == "dns.quad9.net", (
        f"selecting Quad9 set the private DNS hostname to "
        f"{after['private_dns_specifier']!r}")
    assert after["private_dns_mode"] == "hostname", (
        f"the private DNS mode stayed {after['private_dns_mode']!r}")


@scenario("@PRIV-32")
@evidence("measured")
@delta
def test_eos_developer_entries_are_grouped(device):
    """The /e/OS developer entries sit together, under their own heading.

    Read as a sequence, because that is what "grouped" means: the entries
    existing somewhere in a list of two hundred would satisfy any check that
    only looks them up. Here they must follow their heading with nothing of
    AOSP's between them.
    """
    entries = settings_tree.developer_options(device)
    assert "/e/OS developer options" in entries, (
        "no /e/OS section in the developer options")
    start = entries.index("/e/OS developer options")
    ours = [e for e in entries if "/e/" in e and e != "/e/OS developer options"]
    assert ours, "the /e/OS section is empty"
    positions = [entries.index(e) for e in ours]
    assert all(start < p <= start + len(ours) * 2 for p in positions), (
        f"the /e/OS entries are not gathered under their heading: "
        f"heading at {start}, entries at {positions}")
