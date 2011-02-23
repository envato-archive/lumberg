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
  s.summary     = %q{WHM & cPanel Ruby Library}
  s.description = %q{Access the WHM & cPanel JSON API with Ruby}

  s.rubyforge_project = "lumberg"

  s.add_dependency 'json'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'rcov'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
