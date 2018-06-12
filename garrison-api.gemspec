
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "garrison/api/version"

Gem::Specification.new do |spec|
  spec.name          = "garrison-api"
  spec.version       = Garrison::Api::VERSION
  spec.authors       = ["Forward3D Developers"]
  spec.email         = ["developers@forward3d.com"]

  spec.summary       = %q{RubyGem to talk to the Garrison API}
  spec.description   = %q{RubyGem to talk to the Garrison API}
  spec.homepage      = "https://github.com/forward3d/garrison"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', '~> 0.16.2'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
