# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kijkwijzer/version'

Gem::Specification.new do |spec|
  spec.name          = "kijkwijzer"
  spec.version       = Kijkwijzer::VERSION
  spec.authors       = ["Maarten Brouwers"]
  spec.email         = ["github.com@murb.nl"]

  spec.summary       = "Retrieves the kijkwijzer rating for a particular title and year"
  spec.description   = "Retrieves the kijkwijzer rating for a particular title and year"
  spec.homepage      = "https://github.com/murb/kijkwijzer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
