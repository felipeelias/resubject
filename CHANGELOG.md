# Changelog

## [1.0.0](https://github.com/felipeelias/resubject/compare/resubject-v0.3.0...resubject/v1.0.0) (2026-03-15)


### Bug Fixes

* drop Rails 7.1 from CI matrix (activesupport 7.1 partial require bug) ([20e7ee5](https://github.com/felipeelias/resubject/commit/20e7ee5828ee69ef03ac32c66ba6823eb0d903d5))
* resolve namespaced presenters without falling back to top-level ([#7](https://github.com/felipeelias/resubject/issues/7)) ([af9fe51](https://github.com/felipeelias/resubject/commit/af9fe51e997e9b355142b48d0283b942b2962114))
* treat Struct and Enumerable objects as single presentables ([#5](https://github.com/felipeelias/resubject/issues/5)) ([7767a5d](https://github.com/felipeelias/resubject/commit/7767a5dad81dd74dfd8dd0cf3edcf80de9bfb4cd))

## 0.2.2
- rubocop style changes

## 0.2.1
- update yard and nokogiri due to security vulnerabilities (only on dev environment)

## 0.2.0

- enhancements
  - Introduce RSpec helpers

## 0.1.1

- bugfixes
  - [#2] presents' implicit presenter class blows up with nil association
- enhancements
  - Calls ActiveSupport.run_load_hooks when gem is loaded

## 0.1.0

- enhancements
  - Add time_ago helper
  - Add percentage helper
  - Add date_format helper

## 0.0.4

- bugfixes
  - Find the presenter in the current object's namespace

## 0.0.3

- Improve docs

## 0.0.2

- Big refactoring
- Add `currency` helper
- Add `presents` helper

## 0.0.1

- Initial commit
