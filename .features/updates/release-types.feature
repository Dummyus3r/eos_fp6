# Source: vendor/lineage/config/version.mk
#   LineageOS accepts   RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL
#   /e/OS accepts       test community official partner
#   anything else falls back to UNOFFICIAL
#   LINEAGE_VERSION_SUFFIX gains CI_PIPELINE_ID; ANDROID_LETTER, maintenance
#   and prerelease components are /e/OS additions
#   published as ro.lineage.releasetype / ro.lineage.version
# Source: vendor/eos/config/common.mk
#   INCLUDE_IH8SN gated on RELEASE_TYPE and on TARGET_BUILD_VARIANT
# Source: packages/apps/Updater
#   Utils#getServerURL substitutes {type}; Utils#canInstall rejects an update
#   whose type differs from ro.lineage.releasetype (both upstream mechanisms,
#   driven by the /e/OS vocabulary)
# Source: build/soong
#   soong: Use our keys for otacerts if it exists (user-keys/releasekey)
#
# This file is the single place the release-type model is specified. Features
# whose behaviour depends on it point here rather than restating it.

@vendor-lineage @updater @build @updates
Feature: Release types

  LineageOS classifies builds as RELEASE, NIGHTLY, SNAPSHOT or EXPERIMENTAL —
  a vocabulary about build cadence. /e/OS replaces it with one about who the
  build is for: a device sold with /e/OS preinstalled, a device flashed by an
  enthusiast, a partner's device, or an internal test. Several behaviours differ
  along that line, and the release type is also what pins a device to an update
  channel, so a community device is never offered an official build.

  Background:
    Given an /e/OS build

  Rule: The vocabulary is /e/OS's own

    Scenario Outline: An accepted release type is carried through to the device
      Given the build is declared as "<type>"
      Then the release type property reads "<type>"
      And the version string contains "<type>"

      Examples:
        | type      |
        | official  |
        | community |
        | partner   |
        | test      |

    Scenario: An unrecognised release type falls back
      Given the build is declared with a release type /e/OS does not recognise
      Then the release type becomes "UNOFFICIAL"
      And any extra version string is cleared

    Scenario: A LineageOS release type is not recognised
      Given the build is declared as "NIGHTLY"
      Then the release type becomes "UNOFFICIAL"

    Scenario: An unofficial build can still be identified
      Given the release type is "UNOFFICIAL"
      And the builder has set an unofficial build identifier
      Then that identifier appears in the version string

  Rule: The version string identifies the build that produced it

    Scenario: The version carries the /e/OS version, the Android generation and the build
      When the user opens "About phone"
      Then the version string contains the /e/OS major and minor version
      And the maintenance version when there is one
      And the Android generation
      And the build date, the release type and the device

    Scenario: A prerelease is marked as such
      Given the build is a prerelease
      Then the prerelease name appears in the version string
      And its prerelease number when there is one

    Scenario: A build can be traced back to the pipeline that produced it
      Given the build was produced by the /e/OS build pipeline
      Then the pipeline identifier appears in the version string

  Rule: A device stays on the channel it was released on

    The update channel is the device's own release type. This mechanism comes
    from LineageOS; what /e/OS changes is the vocabulary it operates on.

    Scenario: The device asks for updates of its own type
      Given the device reports release type "community"
      When the updater checks for updates
      Then the request it sends carries "community"

    Scenario: An update of another type is refused
      Given the device reports release type "community"
      And an available update is of type "official"
      When the updater evaluates it
      Then the update is not offered

    Scenario Outline: Each channel is independent
      Given the device reports release type "<type>"
      Then it is only ever offered updates of type "<type>"

      Examples:
        | type      |
        | official  |
        | community |
        | partner   |

  Rule: What is shipped differs by release type

    Scenario: The integrity compatibility daemon
      Given the release type is official, community or partner
      And the build variant is not "user"
      Then the integrity compatibility daemon is included in the image
      # The build variant is tested first and wins: see
      # compatibility/play-integrity-compat.feature

    Scenario: A test build does not ship the integrity compatibility daemon
      Given the release type is "test"
      Then the integrity compatibility daemon is not included in the image

    Scenario: An unofficial build does not ship it either
      Given the release type is "UNOFFICIAL"
      Then the integrity compatibility daemon is not included in the image

  Rule: Signing follows the release, not the release type directly

    /e/OS official images are signed with /e/'s own release keys, supplied to
    the build as a key directory. A build without that directory — a community
    or local build — falls back to the configured development certificate. The
    correlation with the release type is a property of how builds are produced,
    not a rule in the build system.

    Scenario: A build with the /e/OS release keys
      Given the build tree contains the /e/OS release key pair
      Then the OTA certificate shipped in the image is that key's certificate
      And updates signed with it are accepted

    Scenario: A build without them
      Given the build tree does not contain a release key pair
      Then the configured development certificate is used
      And an /e/OS official update is not installable on that build
