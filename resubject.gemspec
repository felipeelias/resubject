lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resubject/version'

Gem::Specification.new do |gem|
  gem.name          = 'resubject'
  gem.version       = Resubject::VERSION
  gem.authors       = ['Felipe Elias Philipp', 'Piotr Jakubowski']
  gem.email         = ['felipe@applicake.com', 'piotr.jakubowski@applicake.com']
  gem.description   = 'Uber simple presenters'
  gem.summary       = "Uber simple presenters using Ruby's SimpleDelegator"
  gem.homepage      = 'https://github.com/felipeelias/resubject'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '>= 3.2'

  gem.add_development_dependency 'rake', '~> 12.0'
  gem.add_development_dependency 'rspec', '~> 3.8.0'
  gem.add_development_dependency 'yard', '~> 0.9'
end
