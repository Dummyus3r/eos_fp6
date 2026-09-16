# Source: external/prebuiltapks/Browser/Android.bp
#   two independent android_app_import modules — Browser (ChromePublic.apk) and
#   BrowserWebView (SystemWebView.apk) — per architecture, signed with the
#   platform certificate; BrowserWebView overrides the AOSP "webview" module,
#   Browser overrides Jelly, Browser2 and QuickSearchBox
# Decision recorded in e/os/backlog#3709: the Trichrome layout (three APKs with
#   an install order) was replaced by the standalone layout, at a size cost,
#   so that the browser can be updated independently of the OS and of WebView.
# Migration to Blueprint (e/os/backlog#3700, #3709) is what made this possible:
#   no Android.mk remains in external/prebuiltapks.

@prebuiltapks @apps @security @prebuilt-boundary
Feature: The browser and the WebView are updated independently of the system

  The browser is the largest attack surface on the device, and the WebView is
  the second. On LineageOS both are tied to the system image: a browser fix
  waits for the next OTA. /e/OS packages them as two independent applications so
  a browser fix can reach users through the store, without an OS release.

  The browser's own behaviour is specified in its repository; what is specified
  here is how the system ships it.

  Background:
    Given a freshly flashed /e/OS device

  Scenario: The browser and the WebView are separate applications
    Then the browser is installed as its own package
    And the WebView is installed as its own package
    And neither requires the other to be installed first

  Scenario: The browser can be updated without the system
    Given a newer browser version is published to the store
    When the user updates it
    Then the update installs
    And it does not require an OS update
    And it does not require the WebView to be updated at the same time

  Scenario: The WebView replaces the AOSP one
    Then the /e/OS WebView is the WebView provider
    And the AOSP WebView is not shipped

  Scenario: The browser replaces the LineageOS and AOSP browsers
    Then no LineageOS or AOSP browser is shipped alongside it
    And no Google search widget is shipped

  Scenario: Both are built for the device's architecture
    Then the APK matching the device architecture is installed
    And no APK for another architecture is included in the image

  Rule: The cost of this layout is accepted deliberately

    The standalone layout is larger than the Trichrome layout, which shares code
    between the browser and the WebView. That size was traded for the ability to
    ship a browser security fix without an OS release.

    Scenario: The image carries both applications in full
      Then the browser and the WebView each carry their own copy of the engine
      And the image is correspondingly larger than one using a shared library layout
