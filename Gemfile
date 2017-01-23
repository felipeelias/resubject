ENV['rails'] ||= '3.2'

source 'https://rubygems.org'

rails_version = ENV['rails']

case rails_version
when '3.2'
  gem 'actionpack', "~> #{rails_version}"
when '4.0'
  # Waiting for beta release of actionpack
  gem 'rails', github: 'rails/rails'
end

gem 'redcarpet'

# Specify your gem's dependencies in resubject.gemspec
gemspec
