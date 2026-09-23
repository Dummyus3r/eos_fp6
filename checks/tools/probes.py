#!/usr/bin/env python3
"""Read-only probes against a built image or a running device.

Two sources of evidence, deliberately separate:

* **artefact probes** read `out/target/product/<device>/` and need no device.
  They run seconds after a build and cover everything /e/OS settles at build
  time — properties, the package set per partition, pre-granted permissions,
  resource values.
* **device probes** go through `adb` and need a booted device. They cover what
  only exists at runtime — effective permission grants, default roles, settings.

Prefer an artefact probe when both can answer: it is faster, it needs no boot,
and it cannot be perturbed by the state a previous run left behind.

Nothing here writes to the device.
"""
from __future__ import annotations

import os
import re
import shutil
import subprocess
from functools import lru_cache

ADB = shutil.which("adb") or "adb"


class ProbeError(RuntimeError):
    """A probe could not be answered — the device is gone, the file is absent."""


# --------------------------------------------------------------------------
# device probes
# --------------------------------------------------------------------------

def _adb(serial: str, *args: str) -> str:
    cmd = [ADB]
    if serial:
        cmd += ["-s", serial]
    cmd += list(args)
    out = subprocess.run(cmd, capture_output=True, text=True)
    if out.returncode != 0:
        raise ProbeError(f"{' '.join(cmd)} failed: {out.stderr.strip()[:200]}")
    return out.stdout.replace("\r", "")


@lru_cache(maxsize=None)
def _props(serial: str) -> dict[str, str]:
    """Every system property, read once per device per run."""
    props = {}
    for line in _adb(serial, "shell", "getprop").splitlines():
        m = re.match(r"^\[(.+?)\]: \[(.*)\]$", line)
        if m:
            props[m.group(1)] = m.group(2)
    return props


def prop(name: str, serial: str = "") -> str:
    """A system property. Absent properties read as the empty string, as on device."""
    return _props(serial).get(name, "")


@lru_cache(maxsize=None)
def packages(serial: str = "") -> frozenset[str]:
    """Installed package names."""
    out = _adb(serial, "shell", "pm", "list", "packages")
    return frozenset(l.split(":", 1)[1] for l in out.splitlines() if ":" in l)


def granted_permissions(package: str, serial: str = "") -> frozenset[str]:
    """Permissions actually granted to a package, as the package manager sees them."""
    out = _adb(serial, "shell", "dumpsys", "package", package)
    granted = set()
    for line in out.splitlines():
        m = re.match(r"\s*(android\.permission\.[A-Z_0-9.]+): granted=true", line.strip())
        if m:
            granted.add(m.group(1))
    return frozenset(granted)


def setting(namespace: str, key: str, serial: str = "") -> str:
    """A value from settings global/secure/system. 'null' is normalised to ''."""
    value = _adb(serial, "shell", "settings", "get", namespace, key).strip()
    return "" if value == "null" else value


def resumed_activity(serial: str = "") -> str:
    """The component currently in the foreground, e.g. 'com.android.settings/.Foo'."""
    out = _adb(serial, "shell", "dumpsys", "activity", "activities")
    m = re.search(r"topResumedActivity=ActivityRecord\{\S+ \S+ (\S+)", out)
    if not m:
        raise ProbeError("no resumed activity - is the device awake?")
    return m.group(1)


def ui_dump(serial: str = "") -> str:
    """The current view hierarchy as XML.

    Screens that set FLAG_SECURE dump an empty hierarchy; that is Android
    refusing the capture, not a probe failure, so callers should fall back to
    `resumed_activity` there rather than treat it as an error.
    """
    _adb(serial, "shell", "uiautomator", "dump", "/sdcard/ui.xml")
    return _adb(serial, "shell", "cat", "/sdcard/ui.xml")


# --------------------------------------------------------------------------
# artefact probes - no device needed
# --------------------------------------------------------------------------

def build_prop(name: str, product_out: str) -> str:
    """A property as written into the built image, before anything boots."""
    for partition in ("system", "product", "system_ext", "vendor"):
        path = os.path.join(product_out, partition, "build.prop")
        if not os.path.exists(path):
            path = os.path.join(product_out, partition, "etc", "build.prop")
        if not os.path.exists(path):
            continue
        with open(path, errors="ignore") as fh:
            for line in fh:
                if line.startswith(f"{name}="):
                    return line.split("=", 1)[1].strip()
    return ""


def shipped_apks(product_out: str) -> frozenset[str]:
    """APK base names present in the built image, by partition scan."""
    found = set()
    for partition in ("system", "product", "system_ext", "vendor"):
        root = os.path.join(product_out, partition)
        for dirpath, _dirnames, filenames in os.walk(root):
            for name in filenames:
                if name.endswith(".apk"):
                    found.add(os.path.splitext(name)[0])
    return frozenset(found)
