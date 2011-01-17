# -*- encoding: utf-8 -*-
require File.expand_path("../lib/txtlocal/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "txtlocal"
  s.version     = Txtlocal::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Glen Mailer"]
  s.email       = ["glen@epigenesys.co.uk"]
  s.homepage    = "https://github.com/epigenesys/txtlocal"
  s.summary     = "An API wrapper for txtlocal.co.uk"
  s.description = "An API wrapper for txtlocal.co.uk"

  s.required_rubygems_version = ">= 1.3.6"
  #s.rubyforge_project         = "txtlocal"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "autotest"
  s.add_development_dependency "webmock"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
