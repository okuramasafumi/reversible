# frozen_string_literal: true

require_relative 'lib/reversible/version'

Gem::Specification.new do |spec|
  spec.name = 'reversible'
  spec.version = Reversible::VERSION
  spec.authors = ['OKURA Masafumi']
  spec.email = ['masafumi.o1988@gmail.com']

  spec.summary = 'Provides reversible method definition, inspired by ActiveRecord Migration'
  spec.description = 'Provides reversible method definition, inspired by ActiveRecord Migration'
  spec.homepage = 'https://github.com/okuramasafumi/reversible'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/okuramasafumi/reversible'
  spec.metadata['changelog_uri'] = 'https://github.com/okuramasafumi/reversible/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
