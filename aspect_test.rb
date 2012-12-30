require 'test/unit'
require 'aquarium'
require 'aquarium/dsl/object_dsl'
include Aquarium::Aspects


class AspectTest  < Test::Unit::TestCase

  def test_advice_on_object
    extend Aspect::DSL
    object = SomeClass.new
    Aspect.new :after, methods: [:foo], for_objects: [object] do |jp|
      puts "aop here"
    end
    object.foo
    object_2 = SomeClass.new
    object_2.foo

  end

end


class SomeClass
  def foo
    puts "foo called"
  end
end