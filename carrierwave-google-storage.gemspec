# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/google/storage/version'

Gem::Specification.new do |spec|
  spec.name          = 'carrierwave-google-storage'
  spec.version       = Carrierwave::Google::Storage::VERSION
  spec.authors       = ['Jasdeep Singh']
  spec.email         = ['narang.jasdeep@gmail.com']

  spec.summary       = %q(Use gcloud for Google Cloud Storage support in Carrierwave.)
  spec.description   = %q(A slimmer alternative to using Fog for Google Cloud Storage support in Carrierwave. Heavily inspired from carrierwave-aws)
  spec.homepage      = 'https://github.com/metaware/carrierwave-google-storage'
  spec.license       = 'MIT'

  spec.metadata = {
    'source_code_uri' => spec.homepage,
    'changelog_uri'   => "#{spec.homepage}/blob/master/CHANGELOG.md",
    'bug_tracker_uri' => "#{spec.homepage}/issues"
  }

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'carrierwave', ['>= 1.3.2', '< 4']
  spec.add_dependency 'google-cloud-storage', '~> 1.44'
  spec.add_dependency 'activemodel', '>= 3.2.0'

  spec.add_development_dependency 'bundler', '>= 1.12'
  spec.add_development_dependency 'pry', '>= 0.10.3'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'ssrf_filter', '~> 1.0.0'
  spec.add_development_dependency 'uri-query_params', '~> 0.7.1'
end
