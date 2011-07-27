# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lumberg/version"

Gem::Specification.new do |s|
  s.name        = "lumberg"
  s.version     = Lumberg::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Justin Mazzi"]
  s.email       = ["jmazzi@site5.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby library for the WHM & cPanel API}
  s.description = %q{Ruby library for the WHM & cPanel API; It's not a half day or anything like that}

  s.rubyforge_project = "lumberg"

  s.add_dependency 'json'
  s.add_runtime_dependency('jruby-openssl', '~> 0.7.3') if RUBY_PLATFORM == 'java'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'rake', '~> 0.8.7'
  if !defined?(RUBY_ENGINE) || RUBY_ENGINE != 'rbx'
    s.add_development_dependency 'rcov', '~> 0.9' 
    s.add_development_dependency 'metric_fu', '~> 2.1'
  end

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
