$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "will_filter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "will_filter"
  s.version     = WillFilter::VERSION
  s.authors     = ["Michael Berkovich"]
  s.email       = ["theiceberk@gmail.com"]
  s.homepage    = "https://github.com/berk/will_filter"
  s.summary     = "A filtering engine plugin for Rails 3.1"
  s.description = "will_filter is a powerful customizable framework for filtering active_record models."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.rdoc']
  s.require_paths = ['lib']

  s.licenses = ['MIT']

  s.add_dependency 'rails', ['~> 5.1']
  s.add_dependency 'kaminari', ['~> 1.1']
  s.add_dependency 'sass', ['~> 3.5']
end
