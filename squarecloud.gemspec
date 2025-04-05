lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'squarecloud/version'

Gem::Specification.new do |spec|
  spec.name          = "squarecloud-unofficial"
  spec.version       = Squarecloud::VERSION
  spec.authors       = ["Júlia Klee	"]
  spec.email         = ["me@juliaklee.wtf"]
  spec.summary       = %q{Unofficial Ruby SDK for the Square Cloud API}
  spec.description   = %q{An unofficial Ruby library for interacting with the Square Cloud API, providing Ruby developers with easy access to application management, backup systems, domains, and more}
  spec.homepage      = "https://github.com/kleeedolinux/squarecloud-sdk-rb"
  spec.license       = "MIT"
  spec.metadata      = {
    "source_code_uri" => "https://github.com/kleeedolinux/squarecloud-sdk-rb",
    "documentation_uri" => "https://github.com/kleeedolinux/squarecloud-sdk-rb",
    "rubygems_mfa_required" => "true"
  }

  spec.files         = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_dependency "faraday", "~> 2.7"
  spec.add_dependency "faraday-multipart", "~> 1.0"
  
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "dotenv", "~> 2.8"
  spec.add_development_dependency "rubocop", "~> 1.50"
  spec.add_development_dependency "webmock", "~> 3.18"
end 