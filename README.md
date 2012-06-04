# ActiveSupportAliasClassMethod

[![Build Status](https://secure.travis-ci.org/mrkn/active_support_alias_class_method.png?branch=v1.0_maintenance)](http://travis-ci.org/mrkn/active_support_alias_class_method)

A supplementary library of activesupport to provide ```alias_class_method``` and ```alias_class_method_chain```.

## Installation

Add this line to your application's Gemfile:

    gem 'active_support_alias_class_method'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_support_alias_class_method

## Usage

```ruby
require 'active_support_alias_class_method/core_ext/module'

class Foo
  def self.foo
    :foo
  end

  alias_class_method :bar, :foo
end

Foo.foo #=> :foo
Foo.bar #=> :foo

class Foo
  def self.foo_with_baz
    [:baz, foo_without_baz]
  end

  alias_class_method_chain :foo, :baz
end

Foo.foo #=> [:baz, :foo]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
