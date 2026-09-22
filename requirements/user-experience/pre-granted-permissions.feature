# Proven by: features/apps/default-permissions.feature

@user-experience @requirement
Feature: Default applications are pre-granted the permissions they need, and the user can always take them back

  A user who has just flashed /e/OS should not be walked through a
  permission gauntlet before the preinstalled applications work. /e/OS
  pre-grants each default application only the permissions its function
  requires, so it works out of the box — but the user keeps full control
  afterward: any pre-granted permission can be revoked, and that revocation
  is never silently undone.

  Rule: Pre-granting only smooths first use, it never removes user control

    Scenario: A default application works immediately
      Given a freshly flashed device
      When the user opens a default application for the first time
      Then it already holds the permissions its advertised function requires
      And the user is not shown a runtime permission prompt for them

    Scenario: The user revokes a pre-granted permission
      Given a default application holds a pre-granted permission
      When the user revokes it
      Then the revocation is honoured
      And it is not silently granted again
