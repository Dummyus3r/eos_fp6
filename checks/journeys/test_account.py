"""Checks that need a Murena Workspace account on the device.

They are the only ones in the suite that depend on something the device cannot
provide by itself. Without the credentials file the `account` fixture skips
them with that reason, so a machine with no account still runs a green suite —
and `proven.py` reports the skip rather than letting it read as a pass.
"""
from __future__ import annotations

import pytest

import account as account_journey
import settings
from conftest import delta, evidence, scenario

#: The account types the chooser offers. Used to tell an account row from the
#: address above it and the summary below it, without hard-coding the address.
ACCOUNT_TYPES = {
    "Murena.io", "Murena.io Address book", "Google", "Google Address book",
    "Google microG", "Web Calendar Manager", "WebDAV", "WebDav Address book",
    "Yahoo", "Yahoo Address book",
}


@pytest.fixture(scope="session")
def signed_in(device, account):
    """A device with the test account registered, signed in through the UI.

    Through the UI, not through `AccountManager`: what the scenarios describe is
    the account the *application* creates, and inserting one behind the
    application's back would prove nothing about it.
    """
    if not account_journey.sign_in(device, account):
        pytest.skip("could not sign in with the configured test account")
    return device


@scenario("@ID-3")
@evidence("measured")
@delta
def test_adding_an_account_goes_through_the_eos_account_manager(device):
    """From an empty contact list, adding an account has to land in /e/OS's manager.

    The walk is the full path a user takes — *Contacts → Add account → the
    account chooser → Murena.io* — because the promise is about where that path
    ends, not about the manager being installed.

    It needs a device with no account: the button belongs to the empty state of
    the contact list, and once an account syncs contacts the list is no longer
    empty. Skipped rather than rerouted, because the other routes into the
    chooser go through Settings and would stop testing what this scenario is
    about — what *Contacts* does.
    """
    if any("@" in name for name in account_journey.registered(device)):
        pytest.skip("an account is already registered; this walk needs an empty device")
    reached = account_journey.add_account_from_contacts(device)
    assert account_journey.ACCOUNT_MANAGER in reached, (
        f"adding an account from Contacts reached {reached!r}")


@scenario("@ID-2")
@evidence("measured")
@delta
def test_murena_account_is_listed_first(signed_in):
    """The Murena Workspace account comes before the others in the account list.

    Order, not presence: AOSP's list is unopinionated and the /e/OS change is
    which account the system treats as primary. A check that only looked for the
    account would pass on the list /e/OS set out to reorder.
    """
    entries = settings.read(settings.start(
        signed_in, action="android.settings.SYNC_SETTINGS", expect="Account") and signed_in)
    types = [e for e in entries if e in ACCOUNT_TYPES]
    assert types, f"no account row in the account list: {entries}"
    assert types[0] == "Murena.io", (
        f"the first account listed is of type {types[0]!r}")


@scenario("@ID-7")
@evidence("measured")
@delta
def test_each_address_book_appears_once(signed_in):
    """The contact list filter lists every address book exactly once.

    A Murena Workspace account registers several address books, and the defect
    this guards against is each of them appearing twice — once per provider that
    claims it. So the assertion counts, rather than checking that the drawer
    mentions them.
    """
    entries = account_journey.contacts_drawer(signed_in)
    start = entries.index("Accounts")
    books = []
    for entry in entries[start + 1:]:
        if entry in ("Emergency information", "Settings"):
            break
        books.append(entry)
    assert books, f"no address book listed in the contact list filter: {entries}"
    duplicated = [b for b in set(books) if books.count(b) > 1]
    assert not duplicated, f"address book(s) listed more than once: {duplicated}"
