# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "elan_parser/version"

Gem::Specification.new do |s|
  s.name        = "elan_parser"
  s.version     = ElanParser::VERSION
  s.authors     = ["Aaron Hunter"]
  s.email       = ["aaron@hunter.cx"]
  s.homepage    = ""
  s.summary     = %q{Maps ELAN .eaf files to a ruby object.}
  s.description = %q{Each .eaf file is essentially XML. Each node is mapped to ruby classes using the HappyMapper Gem. Using the Elan Gem you should be able to load in the contents of a .eaf file and get back a ruby object with all of the data.}

  s.rubyforge_project = "elan_parser"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
	s.add_development_dependency "factory_girl"
	s.add_development_dependency "database_cleaner"


  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "happymapper"
  s.add_runtime_dependency "pg"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "activerecord"
end
