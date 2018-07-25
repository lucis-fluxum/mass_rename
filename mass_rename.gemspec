# frozen_string_literal: true

require File.expand_path('lib/mass_rename/version', File.dirname(__FILE__))

Gem::Specification.new do |spec|
  spec.name          = 'mass_rename'
  spec.version       = MassRename::VERSION
  spec.author        = 'Luc Street'
  spec.summary       = 'Mass rename files.'
  spec.description   = 'Filter and rename multiple files in a directory or subdirectories with regular expressions.'
  spec.homepage      = 'https://github.com/lucis-fluxum/mass_rename'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 1.9.3'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.test_files    = `git ls-files -z -- spec/*`.split("\x0")
  spec.executables   = ['mass_rename']

  spec.metadata['yard.run'] = 'yri'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
end
