# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "stamp/version"

Gem::Specification.new do |s|
  s.name        = "stamp"
  s.version     = Stamp::VERSION
  s.authors     = ["Jeremy Weiskotten"]
  s.email       = ["jeremy@weiskotten.com"]
  s.homepage    = "https://github.com/jeremyw/stamp"
  s.summary     = %Q{Date and time formatting for humans.}
  s.description = %Q{Format dates and times based on human-friendly examples, not arcane strftime directives.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- features/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
