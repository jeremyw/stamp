# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "stamp/version"

Gem::Specification.new do |s|
  s.name        = "stamp"
  s.version     = Stamp::VERSION
  s.authors     = ["Jeremy Weiskotten"]
  s.email       = ["jeremy@terriblelabs.com"]
  s.homepage    = "https://github.com/jeremyw/stamp"
  s.summary     = %Q{Date and time formatting for humans.}
  s.description = %Q{Format dates and times based on human-friendly examples, not arcane strftime directives.}
  s.license     = "MIT"

  s.metadata = {
    "source_code_uri" => "https://github.com/jeremyw/stamp",
    "bug_tracker_uri" => "https://github.com/jeremyw/stamp/issues"
  }

  s.required_ruby_version = ">= 3.1"

  s.files         = `git ls-files`.split("\n").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
end
