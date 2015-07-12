# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/mgncvrt/version'

Gem::Specification.new do |spec|
  spec.name          = 'carrierwave-mgncvrt'
  spec.version       = CarrierWave::Mgncvrt::VERSION
  spec.authors       = ['Yuichi Takeuchi']
  spec.email         = ['uzuki05@takeyu-web.com']
  spec.summary       = %q{mgncvrt support for CarrierWave}
  spec.description   = %q{mgncvrt support for CarrierWave}
  spec.homepage      = 'https://github.com/tetuyoko/carrierwave-mgncvrt'
  spec.license       = 'MIT'

  spec.files         =  Dir["{bin,lib}/**/*", "README.md"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'carrierwave'
  spec.add_dependency 'rest-client'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
end
