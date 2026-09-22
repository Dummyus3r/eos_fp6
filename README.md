/e/OS
===========

Getting started
---------------

To get started with /e/OS, you'll need to get familiar with [Source Control Tools](https://source.android.com/setup/develop).

To initialize your local repository using the /e/OS trees, use a command like this:
```
repo init -u https://gitlab.e.foundation/e/os/android.git -b a16 --git-lfs
```
Then to sync up:
```
repo sync
```
Please see the [/e/ documentation](https://doc.e.foundation/how-tos/#build-e-for-a-device) for building instructions, by device.


Specifications
--------------

Two folders describe what /e/OS does, and what it must always do:

- [`features/`](features/README.md) — what /e/OS adds on top of LineageOS, derived from the code.
- [`requirements/`](requirements/README.md) — product-level promises, written independently of the code, and checked against `features/`.

Submitting patches
------------------
Patches are always welcome! Please submit your patches by opening a Merge Request on the project repository you want to contribute!


Continuous Integration
--------

All supported devices are built as new versions are committed to ensuring that the source trees remain buildable.

Builds produced can be downloaded from the [official website](https://doc.e.foundation/devices/).
