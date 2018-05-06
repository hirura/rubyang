# coding: utf-8
# vim: et ts=2 sw=2

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubyang/version'

Gem::Specification.new do |spec|
  spec.name          = "rubyang"
  spec.version       = Rubyang::VERSION
  spec.license       = "Apache-2.0"
  spec.summary       = %q{Pure Ruby YANG parser and tree structure data store implementation}
  spec.description   = %q{Pure Ruby YANG parser and tree structure data store implementation}
  spec.authors       = ["hirura"]
  spec.email         = ["hirura@gmail.com"]
  spec.homepage      = "https://github.com/hirura/rubyang"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency "sinatra",         '~> 1.0'
  spec.add_dependency "sinatra-contrib", '~> 1.0'
  spec.add_dependency "rack-test",       '~> 0.6.3'

  spec.add_development_dependency "bundler",                   '~> 1.16'
  spec.add_development_dependency "rake",                      '~> 11.0'
  spec.add_development_dependency "rspec",                     '~> 3.0'
  spec.add_development_dependency "racc",                      '~> 1.0'
  spec.add_development_dependency "codeclimate-test-reporter", '~> 1.0.8'
end
