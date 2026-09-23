"""The first-boot journey: the setup wizard, end to end.

Declares the sequence /e/OS expects. The /e/OS steps are what this journey
exists for — they are the ones a port can silently drop, and the walk reports a
step that never came by name rather than failing somewhere downstream.
"""
from __future__ import annotations

from model import Journey, Screen

FIRST_BOOT = Journey("first boot", [
    Screen(".WelcomeActivity", marker="Welcome", next_label="Start",
           scenarios=("@BRAND-1", "@SETUP-11")),
    Screen(".LocaleActivity", optional=True, next_label="Next"),
    Screen(".SimMissingActivity", optional=True, next_label="Next"),
    Screen(".NetworkSetupActivity", optional=True, next_label="Skip"),
    Screen(".DateTimeActivity", optional=True, next_label="Next",
           scenarios=("@SETUP-12",)),

    # The /e/OS steps. These are the ones worth walking for.
    Screen(".account.EAccountManagerActivity", next_label="Next",
           scenarios=("@SETUP-13", "@SETUP-14")),
    Screen(".backup.RestoreIntroActivity", optional=True, next_label="Next",
           scenarios=("@SETUP-1", "@SETUP-3")),
    Screen(".parental.ParentalControlActivity", next_label="Skip",
           scenarios=("@SETUP-16", "@SYS-38")),
    Screen(".findmydevice.FindMyDeviceActivity", optional=True, next_label="Skip",
           scenarios=("@SETUP-17", "@SYS-6")),

    Screen(".privacy.LocationSettingsActivity", optional=True, next_label="Next",
           scenarios=("@SETUP-15",)),
    Screen(".system.DeviceSpecificActivity", optional=True, next_label="Next"),
    Screen(".user.BiometricActivity", optional=True, next_label="Skip"),
    # FLAG_SECURE: the hierarchy comes back empty, so the activity is the only
    # evidence and the screen has to be driven blind.
    Screen(".password.SetupChooseLock", marker=None, optional=True, next_label="Skip"),
    Screen(".settings.ThemeSettingsActivity", optional=True, next_label="Next"),
    Screen(".settings.NavigationSettingsActivity", optional=True, next_label="Next"),
    Screen(".FinishActivity", optional=True),
])
