# Source: frameworks/base
#   Make 3rd party app links verification work
#   (packages/StatementService — removal of the network-blocking guard)

@frameworks-base @compatibility
Feature: App links are verified right after installation

  Android verifies an application's declared web links by fetching the
  site's assetlinks.json immediately after installation. That fetch is skipped
  when the device is not charging, so on a phone installed from battery the
  links silently stay unverified and every tap shows a chooser instead of
  opening the application. /e/OS performs the verification regardless.

  Background:
    Given the device runs /e/OS

  @COMPAT-10
  Scenario: Verification happens on battery
    Given the device is not plugged in
    When the user installs an application that declares verified web links
    Then the platform fetches the site's digital asset links file
    And the links are marked as verified

  @COMPAT-11
  Scenario: The verified application opens its own links
    Given an application's web links have been verified
    When the user opens one of those links
    Then the application opens it directly
    And no disambiguation dialog is shown

  @COMPAT-12
  Scenario: Verification still respects the site
    Given a site does not list the application in its digital asset links file
    When the application is installed
    Then its links are not verified
