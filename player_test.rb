require 'test/unit'
require './player'

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
    player = Player.new
    player.add_points(10)
    player.pay(20)
    assert_equal -10, player.points
  end
end