# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vcloud/walker/version"

Gem::Specification.new do |s|
  s.name        = 'vcloud-walker'
  s.version     = Vcloud::Walker::VERSION
  s.authors     = ['Government Digital Service']
  s.homepage    = 'https://github.com/gds-operations/vcloud-walker'
  s.summary     = %q{Command line tool to describe vCloud entities}
  s.description = %q{Vcloud-walker is a command line tool to describe different vCloud entities.
                    This tool is a thin layer around fog api, which exposes summarized vCloud entities
                    in the form of JSON}
  s.license = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.executables   = s.files.grep(%r{^bin/}) {|f| File.basename(f)}
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency 'fog', '>= 1.21.0'
  s.add_runtime_dependency 'json', '~> 1.8.0'
  s.add_runtime_dependency 'vcloud-core', '~> 1.0'
  s.add_development_dependency 'gem_publisher', '1.2.0'
  s.add_development_dependency 'json_spec', '~> 1.1.1'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'rspec-mocks', '~> 2.14.3'
  s.add_development_dependency 'rubocop', '~> 0.23.0'
  s.add_development_dependency 'simplecov', '~> 0.7.1'
end
