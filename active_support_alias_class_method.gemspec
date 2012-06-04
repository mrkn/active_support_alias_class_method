# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_support_alias_class_method/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kenta Murata"]
  gem.email         = ["mrkn@cookpad.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "active_support_alias_class_method"
  gem.require_paths = ["lib"]
  gem.version       = ActiveSupportAliasClassMethod::VERSION

  gem.add_dependency('activesupport', '~> 3.0.0')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('test-unit')
end
