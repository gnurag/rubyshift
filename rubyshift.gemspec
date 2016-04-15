lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubyshift/version'

Gem::Specification.new do |gem|
  gem.name          = "rubyshift"
  gem.version       = RubyShift::VERSION
  gem.authors       = ["Anurag Patel"]
  gem.email         = ["gnurag@gmail.com"]
  gem.description   = %q{Ruby client for OpenShift REST API}
  gem.summary       = %q{A Ruby wrapper for the OpenShift REST API}
  gem.homepage      = "https://github.com/gnurag/rubyshift"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license       = "BSD"

  gem.add_runtime_dependency 'httparty', '~> 0.13'

  gem.add_development_dependency 'pry', '~> 0.10'
  gem.add_development_dependency 'rake', '~> 11.0'
  gem.add_development_dependency 'rspec', '~> 3.4'
  gem.add_development_dependency 'webmock', '~> 1.24'
end
