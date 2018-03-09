# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'libis/workflow/activerecord/version'
require 'date'

# noinspection RubyResolve
Gem::Specification.new do |spec|
  spec.name = 'libis-workflow-activerecord'
  spec.version = ::Libis::Workflow::ActiveRecord::VERSION
  spec.date = Date.today.to_s

  spec.summary = %q{ActiveRecord persistence for the LIBIS Workflow framework.}
  spec.description = %q{Class implementations that use ActiveRecord storage for the LIBIS Workflow framework.}

  spec.author = 'Kris Dekeyser'
  spec.email = 'kris.dekeyser@libis.be'
  spec.homepage = 'https://github.com/libis/workflow-activerecord'
  spec.license = 'MIT'

  # noinspection RubyResolve
  spec.platform = Gem::Platform::JAVA if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'

  spec.files = `git ls-files -z`.split("\0")
  spec.executables = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'libis-workflow', '~> 2.0'
  spec.add_runtime_dependency 'activerecord', '~> 5'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'sqlite3'
  spec.add_runtime_dependency 'pg'

end
