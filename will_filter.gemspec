lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "will_filter"
  gem.version       = IO.read('VERSION')
  gem.authors       = ["Michael Berkovich"]
  gem.email         = ["michael@geni.com"]
  gem.description   = %q{Filtering framework for Rails AcitveRecord models}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/berk/will_filter"
  gem.license       = 'MIT'

  gem.add_dependency 'rails', '~> 2.3.0'
  gem.add_dependency 'will_paginate', '~> 2.3.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
