# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Resubject is a Ruby gem for building presenters (decorators) using Ruby's `SimpleDelegator`. It provides automatic presenter resolution by naming convention, Rails integration (controller/view `present` helper), and ActionView-based template method extensions (currency, percentage, time_ago, date_format).

Requires Ruby >= 3.1, ActiveSupport >= 7.2. CI tests against Ruby 3.2-3.4 and Rails 7.2-8.0.

## Commands

```bash
bundle exec rake spec        # run all specs
bundle exec rspec spec/resubject/presenter_spec.rb          # run a single spec file
bundle exec rspec spec/resubject/presenter_spec.rb:42       # run a single example by line
bundle exec rubocop          # lint
bundle exec rubocop -a       # lint with auto-fix
RAILS_VERSION=7.2 bundle exec rake spec  # test against a specific Rails version
```

## Architecture

- `lib/resubject/presenter.rb` - Core class inheriting `SimpleDelegator`. Provides `presents` (attribute delegation), `present` (instance-level wrapping), `.all` (collection wrapping), and private helpers (`t`/`l`/`h`/`r` for template context access).
- `lib/resubject/builder.rb` - `Builder.present` resolves and wraps objects with presenters. Handles single objects vs collections, supports stacking multiple presenters via `inject`.
- `lib/resubject/naming.rb` - `Naming.presenter_for` infers presenter class from object (e.g., `Post` -> `PostPresenter`, respects namespaces).
- `lib/resubject/extensions/template_methods.rb` - Class-level DSL methods (`currency`, `percentage`, `time_ago`, `date_format`) that generate instance methods delegating to ActionView helpers.
- `lib/resubject/rails/` - Rails Engine that auto-includes `Resubject::Helpers` into `ActionController`, providing the `present` controller/view helper. Also adds `routes` (`r`) helper to presenters.
- `lib/resubject/rspec.rb` - RSpec config that auto-provides `subject` and `template` for specs in `spec/presenters/`.
- `lib/resubject.rb` - Entry point; conditionally loads Rails integration via `defined? Rails`.

## Conventions

- All Ruby files use `# frozen_string_literal: true`
- RuboCop is configured with `NewCops: enable` targeting Ruby 3.1
- Specs use RSpec 3; presenter specs go in `spec/presenters/` (but current specs are in `spec/resubject/`)
