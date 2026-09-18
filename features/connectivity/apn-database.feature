# Source: vendor/apn (forked from LineageOS/android_vendor_apn)
#   Move our apn config from vendor_lineage
#   ~15 carrier-specific corrections (FR, SE, NO, IT, NL, AT, PT, CA, AU, IN, …)
#   vendor/apn: use apns-conf-mtk.xml if uses_mtk_apns_conf soong config var is set
#   apns-conf.xsd: make type field optional for now
# Source: vendor/lineage
#   vendor/lineage: Hookup TARGET_USES_MTK_APNS_CONF

@vendor-apn @connectivity @device-specific
Feature: Carrier APN database

  /e/OS maintains its own APN database rather than taking the LineageOS one as
  is, because /e/OS devices are sold directly to users in markets where the
  upstream entries are wrong or missing — which shows up as "no mobile data" or
  "MMS do not send" on a brand new phone.
  The MediaTek database applies only to builds configured for it.


  Background:
    Given the device runs /e/OS
    And a SIM card is inserted

  Scenario: Data and MMS work without manual configuration
    When the device registers on the carrier network
    Then the APN matching the carrier's MCC and MNC is selected
    And mobile data and MMS work without the user entering an APN

  Scenario: MVNOs are covered
    Given the SIM belongs to a mobile virtual network operator
    Then a dedicated APN entry exists for it rather than the host network's

  Scenario: Corrections are carried by /e/OS
    Given a carrier whose upstream APN entry is wrong
    Then /e/OS ships the corrected entry

  Scenario: MediaTek devices use their own database
    Given the device is built with the MediaTek APN configuration enabled
    Then the MediaTek APN database is installed instead of the common one

  Scenario: The database is validated
    When the APN database is built
    Then it is checked against the APN schema
