require 'test/unit'
class MonopolyTest  < Test::Unit::TestCase
  def test_fresh_game
    monopoly = MonopolyGame.new
    assert monopoly.players.length == 0
  end
end

class MonopolyGame
  attr_reader :players
  def initialize
    @players = []
  end
end