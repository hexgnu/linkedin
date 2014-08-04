# encoding: utf-8
require File.expand_path('../lib/linked_in/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'hashie', '~> 3.0'
  gem.add_dependency 'multi_json', '~> 1.0'
  gem.add_dependency 'oauth', '~> 0.4'
  # gem.add_development_dependency 'json', '~> 1.6'
  gem.add_development_dependency 'rake', '~> 10'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'kramdown'
  gem.add_development_dependency 'rspec', '~> 2.13'
  gem.add_development_dependency 'simplecov', '~> 0.7'
  gem.add_development_dependency 'vcr', '~> 2.5'
  gem.add_development_dependency 'webmock', '~> 1.11'
  gem.authors = ['Matthew Kirk', 'Wynn Netherland', 'Josh Kalderimis']
  gem.description = 'Ruby wrapper for the LinkedIn API'
  gem.email = ['meteor.kirk@gmail.com', 'wynn.netherland@gmail.com', 'josh.kalderimis@gmail.com']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'http://github.com/hexgnu/linkedin'
  gem.name = 'linkedin'
  gem.licenses = %w[MIT]
  gem.require_paths = ['lib']
  gem.summary = 'This gem interfaces with the Linkedin XML and JSON APis'
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = LinkedIn::VERSION::STRING
end
