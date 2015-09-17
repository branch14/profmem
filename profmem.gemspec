# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'profmem/version'

Gem::Specification.new do |spec|
  spec.name          = "profmem"
  spec.version       = Profmem::VERSION
  spec.authors       = ["phil"]
  spec.email         = ["phil@branch14.org"]
  spec.description   = %q{A simple tool to profile memory, built to identify memory leaks.}
  spec.summary       = %q{A simple tool to profile memory, built to identify memory leaks.}
  spec.homepage      = "http://github.com/branch14/profmem"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
