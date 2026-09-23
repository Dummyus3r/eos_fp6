# Source: packages/apps/SetupWizard
#   Implemented MDM provisioning by QR code
#   Added signature-based checksum support.
# Source: packages/apps/ManagedProvisioning (fork)

@setupwizard @setup @enterprise
Feature: Enrolling a device by QR code during setup

  /e/OS devices are also sold to organisations. The wizard can enrol a device
  into a mobile device management solution by scanning a QR code at first boot,
  which LineageOS does not offer.

  Background:
    Given a device running /e/OS that has never been set up

  @SETUP-8
  Scenario: Enrolment from a QR code
    When the operator scans an enrolment QR code from the wizard
    Then the device owner application described by the code is downloaded and installed
    And the device is provisioned as managed

  @SETUP-9
  Scenario: The downloaded package is verified
    Given the QR code carries a signature checksum
    When the device owner package has been downloaded
    Then its signature is checked against that checksum
    And provisioning is aborted if they do not match

  @SETUP-10
  Scenario: An already provisioned device is not re-provisioned
    Given the device is already provisioned
    When the wizard runs
    Then it does not start provisioning again
