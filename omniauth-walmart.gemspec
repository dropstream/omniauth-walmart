# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-walmart/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "omniauth-walmart"
  spec.authors       = ["Dropstream"]
  spec.email         = [""]
  spec.description   = %q{Omniauth OAuth2 strategy for Walmart Marketplace}
  spec.summary       = %q{Omniauth OAuth2 strategy for Walmart Marketplace}
  spec.homepage      = "https://github.com/dropstream/omniauth-walmart"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($\)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.version       = Omniauth::Walmart::VERSION

  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1.6'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
