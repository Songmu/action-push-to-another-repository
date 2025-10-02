# Changelog

## [v2.0.11](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.10...v2.0.11) - 2025-10-02
- Revert "refactor: simplify workspace handling" by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/43

## [v2.0.10](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.9...v2.0.10) - 2025-10-02
- refactor: simplify workspace handling by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/41

## [v2.0.9](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.8...v2.0.9) - 2025-10-02
- fix fallback by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/39

## [v2.0.8](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.7...v2.0.8) - 2025-10-01
- Bump suzuki-shunsuke/commit-action from 0.0.10 to 0.0.11 by @dependabot[bot] in https://github.com/Songmu/action-push-to-another-repository/pull/36
- fallback to git command when the commit-action failed by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/37

## [v2.0.7](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.6...v2.0.7) - 2025-08-29
- update deps in action.yml and introduce pinact by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/34

## [v2.0.6](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.5...v2.0.6) - 2025-06-25
- set persist-credentials false in action.yml by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/29

## [v2.0.5](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.4...v2.0.5) - 2025-06-25
- add outputs.pushed by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/26
- add Branch Requirements section to README by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/28

## [v2.0.4](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.3...v2.0.4) - 2025-06-25
- make token optional by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/22
- update name of the action by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/24
- Update readme by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/25

## [v2.0.3](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.2...v2.0.3) - 2025-06-25
- update README.md by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/18
- add example of pull to README by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/20
- [incompatible] change argument name to token from github-token by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/21

## [v2.0.2](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.1...v2.0.2) - 2025-06-23
- [bugfix] fix way to output commit message by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/16

## [v2.0.1](https://github.com/Songmu/action-push-to-another-repository/compare/v2.0.0...v2.0.1) - 2025-06-23
- clean changelog by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/13
- [bugfix] fix evacuating git directory by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/15

## [v2.0.0](https://github.com/Songmu/action-push-to-another-repository/compare/v1.7.2...v2.0.0) - 2025-06-23
- Added text regarding fork and maintenance. by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/1
- switch to composite action from Docker by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/2
- remove $SRC/.git before copying to avoid conflict by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/3
- support singned commit by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/4
- refine commit-message variable by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/5
- use official action/checkout and drop create-branch-if-needed feature to simplify code by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/6
- unify 'target' to 'destination' by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/7
- restore origin after sync repository by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/8
- remove unused variables by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/9
- introduce tagpr by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/10
- update README.md by @Songmu in https://github.com/Songmu/action-push-to-another-repository/pull/11
