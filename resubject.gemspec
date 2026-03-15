# frozen_string_literal: true

require_relative 'lib/resubject/version'

Gem::Specification.new do |gem|
  gem.name          = 'resubject'
  gem.version       = Resubject::VERSION
  gem.authors       = ['Felipe Elias Philipp', 'Piotr Jakubowski']
  gem.email         = ['felipe@applicake.com', 'piotr.jakubowski@applicake.com']
  gem.description   = 'Uber simple presenters'
  gem.summary       = "Uber simple presenters using Ruby's SimpleDelegator"
  gem.homepage      = 'https://github.com/felipeelias/resubject'
  gem.license       = 'MIT'

  gem.required_ruby_version = '>= 3.1'

  gem.metadata['homepage_uri'] = gem.homepage
  gem.metadata['source_code_uri'] = gem.homepage
  gem.metadata['changelog_uri'] = "#{gem.homepage}/blob/master/CHANGELOG.md"
  gem.metadata['rubygems_mfa_required'] = 'true'

  gem.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '>= 7.0'
end
