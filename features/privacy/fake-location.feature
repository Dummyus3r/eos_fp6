# Source: frameworks/base
#   feat:2400: fake location from AdvancedPrivacy ContentProvider.
#   fix:8489: Quick return fakelocation. Fix calling package and uid doesn't match
#     to resolve fakeLocationProvider
#   services/core/java/com/android/server/location/FakeLocationResolver.java

@frameworks-base @privacy @location @prebuilt-boundary
Feature: Per-application fake location

  LineageOS can only fake location globally, through the developer-options mock
  location provider, which most applications can detect and which affects the
  whole device. /e/OS lets the user hand a *different* location to a *chosen*
  application while every other application keeps the real one, with nothing to
  enable in developer options.

  The user-facing choice of applications and coordinates is made in Advanced
  Privacy (own repository). What is specified here is the framework side: the
  location service asks Advanced Privacy for an override and applies it.

  Background:
    Given the device runs /e/OS
    And Advanced Privacy exposes the content provider "content://foundation.e.advancedprivacy.fakelocations"

  Scenario: A single application gets the faked coordinates
    Given the user has set a fake location for application "com.example.social"
    When "com.example.social" requests the current location
    Then the latitude and longitude it receives are the ones configured by the user
    And the location is reported as coming from the fused provider

  Scenario: Other applications are unaffected
    Given the user has set a fake location for application "com.example.social"
    When application "com.example.maps" requests the current location
    Then it receives the real device location

  Scenario: Location updates are faked too
    Given the user has set a fake location for application "com.example.social"
    And "com.example.social" has registered for location updates
    When the device moves
    Then every update delivered to "com.example.social" carries the configured coordinates

  Scenario: Geofences follow the faked location
    Given the user has set a fake location for application "com.example.social"
    When "com.example.social" registers a geofence around its faked position
    Then the geofence is evaluated against the faked position

  Scenario: The override is resolved per calling application, not per process
    Given two applications share a UID
    And a fake location is configured only for the first one
    When the second one requests the current location
    Then it receives the real device location

  Scenario: No override configured
    Given no fake location is configured for any application
    When any application requests the current location
    Then it receives the real device location

  # NOT SPECIFIED: what should happen if Advanced Privacy is removed from the
  # device. The code falls through to the real location, but that is the
  # consequence of the implementation, not a decided behaviour. See TODO.md.
