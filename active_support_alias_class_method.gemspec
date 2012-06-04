# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_support_alias_class_method/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kenta Murata"]
  gem.email         = ["mrkn@cookpad.com"]
  gem.description   = %q{A supplementary library of activesupport to provide alias_class_method and alias_class_method_chain}
  gem.summary       = %q{Providing alias_class_method and alias_class_method_chain}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "active_support_alias_class_method"
  gem.require_paths = ["lib"]
  gem.version       = ActiveSupportAliasClassMethod::VERSION

  gem.add_dependency('activesupport', '~> 3.2.0')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('test-unit')
end
