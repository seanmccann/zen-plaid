$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'zen-plaid/version'

Gem::Specification.new do |s|
  s.name        = 'zen-plaid'
  s.version     = Plaid::VERSION
  s.date        = '2014-10-22'
  s.summary     = 'Plaid Ruby Gem'
  s.description = 'Ruby Gem wrapper for Plaid API.'
  s.authors     = ['Sean McCann']
  s.email       = 'sean@smccann.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/seanmccann/zen-plaid'
  s.license     = 'MIT'
  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'oj'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
