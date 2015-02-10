# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'baidu/push/version'
require 'baidu/push'

Gem::Specification.new do |spec|
  spec.name = 'baidu-push'
  spec.version = Baidu::Push::VERSION
  spec.authors = ['scorix']
  spec.email = ['scorix@gmail.com']
  spec.summary = %q{Baidu push client}
  spec.description = %q{}
  spec.homepage = ''
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'celluloid'
  spec.add_dependency 'virtus'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
