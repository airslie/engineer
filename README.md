[![Maintainability](https://api.codeclimate.com/v1/badges/112e9f4a7cda28bd73d7/maintainability)](https://codeclimate.com/github/airslie/engineer/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/112e9f4a7cda28bd73d7/test_coverage)](https://codeclimate.com/github/airslie/engineer/test_coverage)

# Engineer

This gem makes developing a Renalware plugin (a Rails engine) a little easier.
It does most of the standard Engine initialization including:

- appending the engine's `db/migrate`, `db/triggers`, `db/functions` and `db/views` paths to the
  application's `config.paths` so that migrations across all engines and the app itself - and any
  sql definition files referenced in migrations - can be found during a `db:migrate`
- loading any `config/locale/**/*.yml` that exist in the engine.
- more to follow..

## Usage

In your Rails engine add the following to `lib/xxxx/engine.rb`:

```ruby
  class Engine < ::Rails::Engine
    isolate_namespace Renalware::Xxxx
    include Engineer::DefaultInitializers
    ...
  end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'engineer'
```

And then execute:
```bash
$ bundle
```

# Development Tasks

- [ ] Add tests
- [ ] Add a generator to bring in standard files for a new Renalware plugin
- [ ] Look for other Engine boiler-plate code we can move here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
