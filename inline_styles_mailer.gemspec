# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "inline_styles_mailer/version"

Gem::Specification.new do |s|
  s.name        = "inline_styles_mailer"
  s.version     = InlineStylesMailer::VERSION
  s.authors     = ["Bill Horsman"]
  s.email       = ["bill@logicalcobwebs.com"]
  s.homepage    = "https://github.com/billhorsman/inline_styles_mailer"
  s.summary     = %q{Convenient use of inline_styles gem with Rails 3.1}
  s.description = %q{Convenient use of inline_styles gem with Rails 3.1}

  s.rubyforge_project = "inline_styles_mailer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.required_ruby_version = '>= 1.9.2'
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "inline_styles"
  s.add_runtime_dependency "rails", [">= 3.1", "< 4.1"]
  s.add_runtime_dependency "sass-rails"
end
