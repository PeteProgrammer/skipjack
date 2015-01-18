# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skipjack/version'

Gem::Specification.new do |spec|
  spec.name          = "skipjack"
  spec.version       = Skipjack::VERSION
  spec.authors       = ["Peter Strøiman"]
  spec.email         = ["peter@stroiman.com"]
  spec.description   = %q{Rake commands for building .NET code}
  spec.summary       = %q{Rake commands for building .NET code}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_dependency "rake"
  spec.add_dependency "slop"
end
