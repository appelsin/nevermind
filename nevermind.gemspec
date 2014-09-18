# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nevermind/version'

Gem::Specification.new do |spec|
  spec.name          = "nevermind"
  spec.version       = Nevermind::VERSION
  spec.authors       = ["Roman Exempliarov"]
  spec.email         = ["urvala@gmail.com"]
  spec.summary       = 'Abstraction layer that allows to work with multiple models just like with one.'
  spec.description   = 'Working with multiple models like with one. ' +
                       '@posts = Nevermind::Proxy.new(Article, Video).find_by(author: @author)'
  spec.homepage      = "https://github.com/appelsin/nevermind"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "activerecord", "~> 4.0"
  spec.add_development_dependency "sqlite3"
end
