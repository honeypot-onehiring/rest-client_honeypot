# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'rest-client_honeypot'
  spec.version       = '0.0.6'
  spec.authors       = ['Andrzej Trzaska']
  spec.email         = ['atrzaska2@gmail.com']

  spec.summary       = 'Honeypot extensions for restclient gem'
  spec.description   = 'Honeypot extensions for restclient gem.'
  spec.homepage      = 'https://github.com/honeypotio/restclient_honeypot'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/honeypotio/restclient_honeypot'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ['lib']
  spec.add_dependency 'rest-client'
end
