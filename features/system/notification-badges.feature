# Source: frameworks/libs/systemui — iconloaderlib DotRenderer, IconProvider
#   feat(dots): notification count support for launcher3 app badges
#   feat: convert badge to round rect when count > 99
#   DotRenderer: Add shadow to notification dots
#   fix: Properly handle tablet notification icons / Tune further for tablet
#   fix: Revert badge size and position to pre-tablet
#   feat(icons): Add month icon support for calendar
#   fix: Return intended notification count / Render notificationBadges as intended
#   (the a16 badge-geometry rework — density-independent ratio, centring on the
#    first digit — was reverted; this file describes the tree as it stands)
# NOTE: how the launcher feeds the count in is specified in the BlissLauncher3
#       repository. This file specifies the renderer's contract.

@frameworks-libs-systemui @system @prebuilt-boundary
Feature: Notification badges carry a count

  AOSP and LineageOS draw a plain dot on an application icon when it has
  notifications. /e/OS draws the number of notifications, the way users expect
  from the platforms they come from.

  Background:
    Given the device runs /e/OS
    And the icon renderer is asked to draw a badge with a notification count

  @SYS-25
  Scenario: A small count is drawn in a circle
    Given the count is below 10
    Then the badge is drawn as a circle
    And it shows the count as a plain number

  @SYS-26
  Scenario: A two or three digit count widens the badge
    Given the count is 10 or more
    Then the badge is drawn as a rounded rectangle wide enough for the digits

  @SYS-27
  Scenario Outline: Counts of a thousand and above are abbreviated
    Given the count is <count>
    Then the badge reads "<text>"

    Examples:
      | count | text  |
      | 7     | 7     |
      | 42    | 42    |
      | 999   | 999   |
      | 2000  | 2k    |
      | 2500  | 2.5k  |
      | 9900  | 9.9k  |
      | 10000 | 10k+  |
      | 99999 | 10k+  |

  @SYS-28
  Scenario: The badge stays readable over any icon
    Then the badge is drawn with a shadow behind it
    And the count is drawn in bold

  @SYS-29
  Scenario: Badges are sized for the form factor
    Given the device is a tablet
    Then the badge is sized with the tablet ratio rather than the phone one
    And it is nudged inwards when the icon sits at the edge of the screen

  @SYS-30
  Scenario: The taskbar shows a dot without a count
    Given the badge is drawn on a taskbar icon
    Then a plain dot is drawn
    And no count is drawn, because the icon is too small to carry one

  @SYS-31
  Scenario: An icon with no notifications carries no badge
    Given the count is zero
    Then no count is drawn

  @SYS-32
  Scenario: The calendar icon shows the current date
    Given the calendar application declares a month background and a day foreground icon set
    Then its icon is composed from the background for the current month and the foreground for the current day
    And an application that declares only the legacy dynamic icon set keeps using it
