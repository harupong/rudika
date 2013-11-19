# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rudika/version'

Gem::Specification.new do |spec|
  spec.name          = "rudika"
  spec.version       = Rudika::VERSION
  spec.authors       = ["harupong"]
  spec.email         = ["harupong@gmail.com"]
  spec.description   = %q{Schedule recording of Japanese radio programs}
  spec.summary       = %q{Windows app radika ported to Ruby}
  spec.homepage      = "https://github.com/harupong/rudika"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ripdiru", ">= 0.2.0"
  spec.add_dependency "thor"
  spec.add_dependency "whenever"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
