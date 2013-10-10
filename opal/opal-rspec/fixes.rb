# String#<< is not supported by Opal
module RSpec::Expectations
  def self.fail_with(message, expected = nil, actual = nil)
    if !message
      raise ArgumentError, "Failure message is nil. Does your matcher define the " +
                           "appropriate failure_message_for_* method to return a string?"
    end

    raise RSpec::Expectations::ExpectationNotMetError.new(message)
  end
end

# Opal does not support mutable strings
module RSpec::Matchers::Pretty
  def underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word = word.gsub(/([A-Z]+)([A-Z][a-z])/,'$1_$2')
    word = word.gsub(/([a-z\d])([A-Z])/,'$1_$2')
    word = word.tr("-", "_")
    word = word.downcase
    word
  end
end

# make sure should and expect syntax are both loaded
RSpec::Expectations::Syntax.enable_should
RSpec::Expectations::Syntax.enable_expect

# opal doesnt yet support module_exec for defining methods in modules properly
module RSpec::Matchers
  alias_method :expect, :expect
end

# enable_should uses module_exec which does not donate methods to bridged classes
module Kernel
  alias should should
  alias should_not should_not
end

# Module#include should also include constants (as should class subclassing)
RSpec::Core::ExampleGroup::AllHookMemoizedHash = RSpec::Core::MemoizedHelpers::AllHookMemoizedHash

# These two methods break because of instance_variables(). That method should ignore
# private variables added by opal. This breaks as we copy ._klass which makes these 
# collections think they are arrays as we copy the _klass property from an array
class RSpec::Core::Hooks::HookCollection
  def for(example_or_group)
    RSpec::Core::Hooks::HookCollection.
            new(hooks.select {|hook| hook.options_apply?(example_or_group)}).
            with(example_or_group)
  end
end

class RSpec::Core::Hooks::AroundHookCollection
  def for(example, initial_procsy=nil)
    RSpec::Core::Hooks::AroundHookCollection.new(hooks.select {|hook| hook.options_apply?(example)}).
            with(example, initial_procsy)
  end
end

class RSpec::Core::Hooks::HookCollection
  `def.$send = Opal.Kernel.$send`
  `def.$__send__ = Opal.Kernel.$__send__`
  `def.$class = Opal.Kernel.$class`
end

class Array
  def flatten(level = undefined)
    %x{
      var result = [];

      for (var i = 0, length = #{self}.length, item; i < length; i++) {
        item = #{self}[i];

        if (!item._isArray && #{`item`.respond_to?(:to_ary)}) {
          item = item.$to_ary();
        }

        if (item._isArray) {
          if (level == null) {
            result = result.concat(#{`item`.flatten});
          }
          else if (level === 0) {
            result.push(item);
          }
          else {
            result = result.concat(#{`item`.flatten(`level - 1`)});
          }
        }
        else {
          result.push(item);
        }
      }

      return result;
    }
  end
end

