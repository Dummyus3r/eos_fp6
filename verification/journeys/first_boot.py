"""The first-boot journey: the setup wizard, end to end.

Declares the sequence /e/OS expects. The /e/OS steps are the ones this journey
exists for — they are the ones a port can silently drop.
"""
from __future__ import annotations

from model import Journey, Screen

FIRST_BOOT = Journey("first boot", [
    Screen(".WelcomeActivity", marker="Welcome",
           scenarios=("features/branding/identity.feature::Boot",)),
    Screen(".LocaleActivity"),
    Screen(".SimMissingActivity", optional=True),
    Screen(".NetworkSetupActivity"),
    Screen(".DateTimeActivity"),

    # The /e/OS steps.
    Screen(".account.EAccountManagerActivity", marker="sign_in"),
    Screen(".backup.RestoreIntroActivity", optional=True),
    Screen(".parental.ParentalControlActivity", marker="activate_parental_control"),
    Screen(".findmydevice.FindMyDeviceActivity", optional=True),

    Screen(".privacy.LocationSettingsActivity"),
    Screen(".system.DeviceSpecificActivity", optional=True),
    Screen(".user.BiometricActivity", optional=True),
    # FLAG_SECURE: the hierarchy comes back empty, so the activity is the only
    # evidence and the screen has to be driven by resource-id, blind.
    Screen(".user.ScreenLockActivity", marker=None),
    Screen(".settings.ThemeSettingsActivity", optional=True),
    Screen(".settings.NavigationSettingsActivity", optional=True),
    Screen(".FinishActivity"),
])
