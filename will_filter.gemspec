lib = File.expand_path("../lib", __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require "will_filter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "will_filter"
  spec.version     = WillFilter::VERSION
  spec.authors     = ["Michael Berkovich", "Koustubh Sinkar"]
  spec.email       = ["theiceberk@gmail.com", "ksinkar@gmail.com"]
  spec.homepage    = "https://github.com/berk/will_filter"
  spec.summary     = "A filtering engine plugin for Rails 4.x"
  spec.description = "will_filter is a powerful customizable framework for filtering active_record models."

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.extra_rdoc_files = ['README.rdoc']
  spec.require_paths = ['lib']

  spec.licenses = ['MIT']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'spork'
  spec.add_development_dependency 'watchr'
  spec.add_development_dependency 'rr'
  spec.add_development_dependency 'bootstrap-sass'
  spec.add_development_dependency 'sass-rails', '~> 3.2.3'
  spec.add_development_dependency 'coffee-rails', '~> 3.2.1'
  spec.add_development_dependency 'uglifier', '~>1.0.3'
  spec.add_development_dependency 'shoulda-matchers'

  spec.add_runtime_dependency 'rails', '~> 3.2.3'
  spec.add_runtime_dependency 'jquery-rails'
  spec.add_runtime_dependency 'jquery-ui-rails'
  spec.add_runtime_dependency 'kaminari', '~> 0'
  spec.add_runtime_dependency 'sass'
end
