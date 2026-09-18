# Source: external/prebuiltapks
#   config/common.mk, config/telephony.mk — which prebuilt is shipped, and for
#   which platform SDK level; per-SDK variants (…Legacy, …_A12/_A13/_A14, …Slim)
#   Git LFS repository — the APKs themselves are LFS pointers
# Current policy: the prebuilts are refreshed by hand. There is no automated
#   promotion from the application repositories into external/prebuiltapks.

@prebuiltapks @apps @process
Feature: Maintenance of the prebuilt applications

  The /e/OS application set does not build from source in the platform tree: it
  is a set of prebuilt APKs pinned in a Git LFS repository. That pinning is what
  makes a build reproducible, and it is also what makes the application set lag
  behind the application repositories. This file records the policy as it stands
  so that the cost is visible rather than implicit.

  Scenario: Applications are pinned, not tracked
    Given an application repository has published a new version
    When an /e/OS image is built
    Then the version in the image is the one currently committed to the prebuilts repository
    And it does not follow the application repository automatically

  Scenario: Updating a prebuilt is a manual act
    When a maintainer wants to ship a new version of a prebuilt application
    Then they commit the new APK to the prebuilts repository by hand
    And the change is reviewed like any other change

  Scenario: The APKs do not bloat the tree
    Then the APKs are stored as Git LFS objects
    And a checkout without LFS does not pull their contents

  Scenario: A prebuilt can be pinned per Android version
    Given an application ships a different build for an older platform SDK level
    When an image is built for that SDK level
    Then the matching variant is selected
    And the current variant is selected for newer levels

  Scenario: Prebuilts are declared in Blueprint
    Then every prebuilt application is declared as a Blueprint module
    And none relies on a legacy makefile
    # Android 16 restricts what a makefile may do; the migration is what let the
    # browser move to the standalone layout. See apps/browser-and-webview.feature

  Scenario: A build can ship a reduced set
    Given the build is configured as minimal
    Then the optional prebuilts are left out
    And a slimmed variant is used where one exists
