# Source: .gitlab-ci.yml in 83 of the forked projects, including
#   the auto-merge-main and import-updates-from-upstream templates from
#   https://gitlab.e.foundation/e/templates/-/tree/master/gitlab-ci
#   - .gitlab-ci-import-updates-from-upstream.yml
#       a16   -> upstream lineage-23.0, local branch a16
#       a16.1 -> upstream lineage-23.1, a16.2 -> upstream lineage-23.2
#       falls back to the AOSP tag read from e/os/android:<branch>/default.xml
#       when the upstream branch does not exist
#   - .gitlab-ci-auto-merge-main.yml
#       branches matching /^v[0-9](\.[0-9]*){1,2}-(a16)$/ are merged into a16
# Source: the manifest repository itself — snippets/eos.xml, default.xml
# Source: the branch history of the forks
#   a16 was cut at lineage-23.0, /e/OS work arrived above it through merge
#   requests, and the CI re-merged lineage-23.0 afterwards — the base is
#   upstream, not the previous /e/OS generation
# Related: apps/prebuilt-maintenance.feature (the prebuilt applications, which
#   are pinned by hand and deliberately not part of this automation)

@process @build @vendor-lineage
Feature: Keeping the fork current with LineageOS

  /e/OS forks around 85 projects. A fork that is not merged is a fork that
  rots: it stops receiving upstream fixes, and the cost of catching up grows
  until the next Android version has to be started from scratch. LineageOS has
  no equivalent problem and therefore no equivalent machinery. /e/OS automates
  the merge, so a forked project is by default up to date with its LineageOS
  counterpart and a human only intervenes on a conflict.

  Background:
    Given an /e/OS forked project

  Rule: Every fork is merged from its upstream on a schedule

    Scenario: A project forked from LineageOS
      Given the project has a LineageOS counterpart on the matching branch
      When the scheduled pipeline runs on the development branch
      Then the LineageOS branch is merged into the /e/OS development branch
      And the result is pushed without a human intervening

    Scenario: A project forked from AOSP rather than from LineageOS
      Given the project has no LineageOS counterpart branch
      When the scheduled pipeline runs
      Then the AOSP tag declared in the manifest is merged instead
      And the tag is read from the manifest of the branch being updated, not hardcoded

    Scenario: The merge conflicts
      Given the upstream merge does not apply cleanly
      Then the pipeline fails
      And the project stays on its last good state until someone resolves it

    Scenario: The pipeline only runs where it is meant to
      Given a pipeline is triggered by something other than the schedule
      Then the upstream merge does not run

  Rule: A new Android generation starts from upstream, not from the previous one

    The branch for a new generation is cut at that generation's upstream, and
    the /e/OS work is re-applied on top. Cutting it from the previous /e/OS
    branch instead would carry the whole previous Android version forward, and
    turn every later upstream merge into a conflict resolution against stale
    code.

    Scenario: A project forked from LineageOS
      Given a new Android generation
      When its /e/OS development branch is created
      Then it is cut at that generation's LineageOS branch
      And it carries no /e/OS content at that point

    Scenario: A project forked from AOSP rather than from LineageOS
      Given the project has no LineageOS branch for that generation
      When its /e/OS development branch is created
      Then it is cut at the AOSP tag named in the manifest for that generation

    Scenario: The /e/OS work is re-applied, not inherited
      Given the branch has been cut at upstream
      Then the /e/OS changes are brought in on top through merge requests
      And nothing is merged from the previous generation's branch

    Scenario: The delta stays legible
      Given a generation's branch has been prepared
      Then the difference between it and its upstream is exactly the /e/OS work
      And a change that is not carried forward is visibly absent rather than silently inherited

  Rule: Each Android generation tracks its own upstream

    Scenario Outline: A development branch is bound to one LineageOS branch
      Given the /e/OS development branch is "<local>"
      Then it is merged from the LineageOS branch "<upstream>"

      Examples:
        | local  | upstream     |
        | a16    | lineage-23.0 |
        | a16.1  | lineage-23.1 |
        | a16.2  | lineage-23.2 |

  Rule: A fix made on a release reaches the next one

    Release work happens on a release branch, cut from the development branch.
    Without this, a fix shipped in a release would be lost at the next one.

    Scenario: A commit pushed to a release branch
      Given a commit is pushed to a release branch of an Android generation
      Then it is merged back into that generation's development branch automatically

    Scenario: A branch that is not a release branch
      Given a commit is pushed to a branch that is not named as a release branch
      Then nothing is merged back automatically

  Rule: A release branch may fork more projects than the development branch

    This is the consequence that surprises readers of the manifest. A project is
    forked either because /e/OS changes it, or only so that a month's security
    patch can be carried ahead of LineageOS. The second kind is created on the
    release branch and has no reason to exist on the development branch.

    Scenario: A project forked to carry /e/OS changes
      Given a project /e/OS modifies
      Then it is forked on both the development branch and the release branches

    Scenario: A project forked only to carry a security patch
      Given a project /e/OS does not otherwise modify
      And a security bulletin fix has to be carried ahead of LineageOS
      Then it is forked on the release branch
      And it need not be forked on the development branch

    Scenario: Reading the manifest
      Given a reader compares the development and release manifests
      Then the difference in the number of forks is explained by the security patch forks
      And it does not mean the development branch has lost /e/OS features
