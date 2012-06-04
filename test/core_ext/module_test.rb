require 'abstract_unit'
require 'active_support_alias_class_method/core_ext/module'

module BarClassMethodAliaser
  def self.included(foo_class)
    foo_class.class_eval do
      extend BarClassMethods
      alias_class_method_chain :bar, :baz
    end
  end
end

module BarClassMethods
  def bar_with_baz
    bar_without_baz << '_with_baz'
  end

  def quux_with_baz!
    quux_without_baz! << '_with_baz'
  end

  def quux_with_baz?
    false
  end

  def quux_with_baz=(v)
    send(:quux_without_baz=, v) << '_with_baz'
  end

  def duck_with_orange
    duck_without_orange << '_with_orange'
  end
end

class ClassMethodAliasingTest < Test::Unit::TestCase
  def setup
    Object.const_set :FooClassWithBarClassMethod, Class.new { def self.bar() 'bar' end }
    @class = Class.new(FooClassWithBarClassMethod)
  end

  def teardown
    Object.instance_eval { remove_const :FooClassWithBarClassMethod }
  end

  def test_alias_class_method_chain
    assert @class.respond_to?(:bar)
    feature_aliases = [:bar_with_baz, :bar_without_baz]

    feature_aliases.each do |method|
      assert !@class.respond_to?(method)
    end

    assert_equal 'bar', @class.bar

    FooClassWithBarClassMethod.class_eval { include BarClassMethodAliaser }

    feature_aliases.each do |method|
      assert_respond_to @class, method
    end

    assert_equal 'bar_with_baz', @class.bar
    assert_equal 'bar', @class.bar_without_baz
  end

  def test_alias_class_method_chain_with_punctuation_method
    FooClassWithBarClassMethod.class_eval do
      def self.quux!; 'quux' end
    end

    assert !@class.respond_to?(:quux_with_baz!)
    FooClassWithBarClassMethod.class_eval do
      include BarClassMethodAliaser
      alias_class_method_chain :quux!, :baz
    end
    assert_respond_to @class, :quux_with_baz!

    assert_equal 'quux_with_baz', @class.quux!
    assert_equal 'quux', @class.quux_without_baz!
  end

  def test_alias_class_method_chain_with_same_names_between_predicates_and_bang_methods
    FooClassWithBarClassMethod.class_eval do
      def self.quux!; 'quux!' end
      def self.quux?; true end
      def self.quux=(v); 'quux=' end
    end

    assert !@class.respond_to?(:quux_with_baz!)
    assert !@class.respond_to?(:quux_with_baz?)
    assert !@class.respond_to?(:quux_with_baz=)

    FooClassWithBarClassMethod.class_eval { include BarClassMethodAliaser }
    assert_respond_to @class, :quux_with_baz!
    assert_respond_to @class, :quux_with_baz?
    assert_respond_to @class, :quux_with_baz=


    FooClassWithBarClassMethod.alias_class_method_chain :quux!, :baz
    assert_equal 'quux!_with_baz', @class.quux!
    assert_equal 'quux!', @class.quux_without_baz!

    FooClassWithBarClassMethod.alias_class_method_chain :quux?, :baz
    assert_equal false, @class.quux?
    assert_equal true,  @class.quux_without_baz?

    FooClassWithBarClassMethod.alias_class_method_chain :quux=, :baz
    assert_equal 'quux=_with_baz', @class.send(:quux=, 1234)
    assert_equal 'quux=', @class.send(:quux_without_baz=, 1234)
  end

  def test_alias_class_method_chain_with_feature_punctuation
    FooClassWithBarClassMethod.class_eval do
      def self.quux; 'quux' end
      def self.quux?; 'quux?' end
      include BarClassMethodAliaser
      alias_class_method_chain :quux, :baz!
    end

    assert_nothing_raised do
      assert_equal 'quux_with_baz', @class.quux_with_baz!
    end

    assert_raise(NameError) do
      FooClassWithBarClassMethod.alias_class_method_chain :quux?, :baz!
    end
  end

  def test_alias_class_method_chain_yields_target_and_punctuation
    args = nil

    FooClassWithBarClassMethod.class_eval do
      def self.quux?; end
      extend BarClassMethods

      FooClassWithBarClassMethod.alias_class_method_chain :quux?, :baz do |target, punctuation|
        args = [target, punctuation]
      end
    end

    assert_not_nil args
    assert_equal 'quux', args[0]
    assert_equal '?', args[1]
  end

  def test_alias_method_chain_preserves_private_method_status
    FooClassWithBarClassMethod.class_eval do
      def self.duck; 'duck' end
      include BarClassMethodAliaser
      private_class_method :duck
      alias_class_method_chain :duck, :orange
    end

    assert_raise NoMethodError do
      @class.duck
    end

    assert_equal 'duck_with_orange', @class.instance_eval { duck }
    assert FooClassWithBarClassMethod.singleton_class.private_method_defined?(:duck)
  end

  def test_alias_method_chain_preserves_protected_method_status
    FooClassWithBarClassMethod.class_eval do
      def self.duck; 'duck' end
      include BarClassMethodAliaser
      class << self
        protected :duck
      end
      alias_class_method_chain :duck, :orange
    end

    assert_raise NoMethodError do
      @class.duck
    end

    assert_equal 'duck_with_orange', @class.instance_eval { duck }
    assert FooClassWithBarClassMethod.singleton_class.protected_method_defined?(:duck)
  end

  def test_alias_method_chain_preserves_public_method_status
    FooClassWithBarClassMethod.class_eval do
      def self.duck; 'duck' end
      include BarClassMethodAliaser
      public_class_method :duck
      alias_class_method_chain :duck, :orange
    end

    assert_equal 'duck_with_orange', @class.duck
    assert FooClassWithBarClassMethod.singleton_class.public_method_defined?(:duck)
  end
end
