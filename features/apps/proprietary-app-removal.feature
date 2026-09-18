# Source: vendor/eos remove/Android.mk (RemoveProprietaryApps)

@vendor-eos @apps @privacy
Feature: Google proprietary blobs are stripped from device builds

  Device trees — including the ones /e/OS reuses from LineageOS and from vendors
  — pull in Google prebuilt packages such as hotword enrolment, device
  personalisation services and on-device intelligence models. /e/OS overrides
  them all so they never reach the image.

  Scenario: Hotword enrolment blobs are absent
    Given a device tree that declares Google hotword enrolment packages
    When an /e/OS image is built for that device
    Then none of those packages are present in the image

  Scenario: Device personalisation and on-device intelligence blobs are absent
    Given a device tree that declares device personalisation or network intelligence prebuilts
    When an /e/OS image is built for that device
    Then none of those packages are present in the image

  Scenario: Ambient sensing is absent
    Given a device tree that declares the ambient sense prebuilt
    When an /e/OS image is built for that device
    Then that package is not present in the image
