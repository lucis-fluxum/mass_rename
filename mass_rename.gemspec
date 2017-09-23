# frozen_string_literal: true

require_relative 'lib/mass_rename/version'

Gem::Specification.new do |spec|
  spec.name          = 'mass_rename'
  spec.version       = MassRename::VERSION
  spec.authors       = ['Luc Street']
  spec.summary       = 'Mass rename files.'
  spec.description   = 'Filter and rename multiple files in a directory or subdirectories with regular expressions.'
  spec.homepage      = 'https://github.com/lucis-fluxum/mass_rename'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.metadata['yard.run'] = 'yri'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'yard'
end
