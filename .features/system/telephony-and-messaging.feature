# Source: packages/apps/Dialer
#   dialer: callrecord: Enable call recording by default with VOICE_CALL as source
#   3736-R-Hide_voice_search_button
# Source: packages/apps/Contacts
#   Contacts: Support changing vCard export version
#   Contacts: show labels for contacts
# Source: frameworks/opt/vcard
#   fixed: exporting custom field for IM
# Source: packages/apps/EmergencyInfo
#   EmergencyInfo: Ask to unlock to view emergency contact
# Source: vendor/lineage
#   vendor/lineage: telephony: Default enable mobile data OOTB

@dialer @contacts @telephony @system @device-specific
Feature: Telephony and contacts behaviour

  Small but deliberate differences in the telephony applications /e/OS ships.
  Call recording depends on the device supporting the voice-call audio source;
  its legality is the user's responsibility, not the platform's.


  Background:
    Given the device runs /e/OS

  Scenario: Mobile data works on first boot
    Given a SIM is inserted in a freshly flashed device
    When the device registers on the network
    Then mobile data is enabled without the user configuring anything

  Scenario: Call recording is available without being enabled first
    Given LineageOS ships the same dialer with call recording disabled
    Then /e/OS ships it enabled, unconditionally
    And the setting does not depend on the build variant or on the region

  Scenario: Recording captures both sides of the call
    Given the device supports the voice call audio source
    When the user records a call
    Then the recording uses the voice call uplink and downlink source
    And not the microphone source LineageOS defaults to

  Scenario: No voice search in the dialer
    When the user opens the dialer
    Then no voice search button is offered

  Scenario: Contacts can be exported in a chosen vCard version
    When the user exports contacts
    Then they can choose the vCard version to produce

  Scenario: Custom instant-messaging fields survive an export
    Given a contact has a custom instant-messaging field
    When the contact is exported to vCard
    Then the custom field is present in the export

  Scenario: Contact labels are shown
    When the user opens a contact
    Then the labels of its phone numbers and addresses are shown

  Scenario: Emergency contacts are protected
    Given the device is locked
    When someone opens the emergency information
    Then viewing the emergency contacts requires unlocking the device
