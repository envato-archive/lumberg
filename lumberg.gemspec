# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lumberg/version"

Gem::Specification.new do |s|
  s.name        = "lumberg"
  s.version     = Lumberg::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Justin Mazzi"]
  s.email       = ["justin@pressed.net"]
  s.homepage    = "https://github.com/pressednet/lumberg"
  s.summary     = %q{Ruby library for the WHM & cPanel API}
  s.description = %q{Ruby library for the WHM & cPanel API; It's not a half day or anything like that}
  s.license     = 'MIT'

  s.rubyforge_project = "lumberg"

  s.add_runtime_dependency 'json',               '>= 1.8.2'
  s.add_runtime_dependency 'faraday',            '~> 0.12.0'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.12.0'
  s.add_runtime_dependency('jruby-openssl', '>= 0.7.3') if RUBY_PLATFORM == 'java'

  s.add_development_dependency 'rspec', '~> 2.10.0'
  s.add_development_dependency 'webmock', '~> 3.4.0'
  s.add_development_dependency 'vcr', '~> 2.9.2'
  s.add_development_dependency 'rake', '~> 0.9.2.2'

  s.files       += %w[Gemfile LICENSE Rakefile README.md]
  s.files       += Dir['{lib,spec}/**/*']
  s.test_files   = Dir['spec/**/*']
end
