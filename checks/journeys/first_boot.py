"""The first-boot journey: the setup wizard, end to end.

Declares the sequence /e/OS expects. The /e/OS steps are what this journey
exists for — they are the ones a port can silently drop, and the walk reports a
step that never came by name rather than failing somewhere downstream.

Screens are named by their **class alone**, never by their package. a16 keeps
the wizard's activities flat — `org.lineageos.setupwizard.FindMyDeviceActivity`
— and a17's Kotlin rewrite moved them into subpackages,
`org.lineageos.setupwizard.findmydevice.FindMyDeviceActivity`. A model written
against either one reports the other's perfectly good steps as never reached,
which is the loudest possible way to be wrong about a build. The class name is
what survives the move, and it is the same thing a reader recognises.
"""
from __future__ import annotations

from model import Journey, Screen

FIRST_BOOT = Journey("first boot", [
    Screen(".WelcomeActivity", marker="Welcome", next_label=("Start", "Next"),
           scenarios=("@BRAND-1", "@SETUP-11")),
    Screen(".LocaleActivity", optional=True, next_label="Next"),
    Screen(".SimMissingActivity", optional=True, next_label="Next"),
    Screen(".NetworkSetupActivity", optional=True, next_label="Skip"),
    Screen(".DateTimeActivity", optional=True, next_label="Next",
           scenarios=("@SETUP-12",)),

    # The /e/OS steps. These are the ones worth walking for.
    Screen("EAccountManagerActivity", next_label=("Skip", "Next"),
           scenarios=("@SETUP-13", "@SETUP-14")),
    Screen("RestoreIntroActivity", optional=True, next_label=("Skip", "Next"),
           scenarios=("@SETUP-1", "@SETUP-3")),
    Screen("ParentalControlActivity", next_label=("Skip", "Next"),
           scenarios=("@SETUP-16", "@SYS-38")),
    Screen("FindMyDeviceActivity", optional=True, next_label=("Skip", "Next"),
           scenarios=("@SETUP-17", "@SYS-6")),

    Screen("LocationSettingsActivity", optional=True, next_label="Next",
           scenarios=("@SETUP-15",)),
    Screen("DeviceSpecificActivity", optional=True, next_label="Next"),
    Screen("BiometricActivity", optional=True, next_label="Skip"),
    # FLAG_SECURE: the hierarchy comes back empty, so the activity is the only
    # evidence and the screen has to be driven blind.
    Screen("SetupChooseLock", marker=None, optional=True, next_label="Skip"),
    Screen("ThemeSettingsActivity", optional=True, next_label="Next"),
    Screen("NavigationSettingsActivity", optional=True, next_label="Next"),
    Screen(".FinishActivity", optional=True),
])
