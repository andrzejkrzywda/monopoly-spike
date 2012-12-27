require 'test/unit'

class Person
end

module Player
  def lifes
  	@lifes ||= []
  end
end

class ExtendRuntimeWithDataTest  < Test::Unit::TestCase
  def test_extend
  	andrzej = Person.new
  	andrzej.extend(Player)
  	assert_equal [], andrzej.lifes
  	o = Object.new
  	andrzej.lifes << o
  	assert_equal [o], andrzej.lifes
  end
end