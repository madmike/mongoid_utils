# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid_utils"
  spec.version       = Mongoid::Utils::VERSION
  spec.authors       = ["Michail"]
  spec.email         = ["xbiznet@gmail.com"]

  spec.summary       = %q{Useful concerns for mongoid ORM for the rails framework. Including commentable, hitable, votable and so on...}
  spec.description   = %q{A set of Mongoid model concerns for adding functionality of commentable, votable, hitable models and some other nice add ons}
  spec.homepage      = "https://github.com/madmike/mongoid_utils"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://rubygems.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "mongoid"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
