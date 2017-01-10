# encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bling/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'bling-ruby-api'
  s.version     = Bling::VERSION
  s.summary     = 'Gem to access Bling API in ruby'
  s.description = 'Gem to access Bling API in ruby'
  s.required_ruby_version = '>= 2.1'

  s.author    = 'Denis Tierno'
  s.email     = 'contato@locomotiva.pro'
  s.homepage  = 'http://locomotiva.pro'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = s.files.grep(%r{^(spec|features)/})
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'rake'

  s.add_development_dependency 'rspec'
end
