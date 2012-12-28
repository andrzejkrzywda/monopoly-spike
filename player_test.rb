require 'test/unit'
require './monopoly'

include Monopoly

class PlayerTest  < Test::Unit::TestCase
  def test_paying_and_points
    person = Player.new
    assert_equal 0, person.points
    person.add_points(120)
    assert_equal 120, person.points
    person.pay(50)
    assert_equal(70, person.points)
  end

  def test_cant_afford
    person = Player.new
    person.add_points(10)
    assert_raise(NotEnoughPointsToPay) { person.pay(20) }
  end
end