# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-fair-json"
  spec.authors       = ["Marshall Brekka"]
  spec.version       = "0.0.1"
  spec.email         = ["marshallb@fair.com"]
  spec.homepage      = "https://github.com/wearefair/fluent-plugin-json"
  spec.summary       = "Parses json field in a log record"
  spec.description   = "Parses json field in a log record"

  spec.files         = `git ls-files app lib`.split("\n")
  spec.platform      = Gem::Platform::RUBY
  spec.require_paths = ['lib']

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.add_dependency "fluentd", ">= 0.14.0", "< 2"
end
