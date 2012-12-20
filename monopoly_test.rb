require 'test/unit'
  
class MonopolyTest  < Test::Unit::TestCase
  def new_monopoly_game
    Monopoly::Game.new
  end

  def new_player
    Monopoly::Player.new
  end

  def test_game_allows_many_players
    monopoly = new_monopoly_game
    andrzej  = new_player
    nthx     = new_player

    monopoly.join(andrzej)
    monopoly.join(nthx)
    monopoly.play(andrzej)
    monopoly.play(nthx)
    monopoly.play(nthx)
  end

  def test_game_limits_moves_to_3
    monopoly = new_monopoly_game
    andrzej  = new_player
    monopoly.join(andrzej)

    monopoly.play(andrzej)
    monopoly.play(andrzej)
    monopoly.play(andrzej)
    assert_raises Monopoly::NoMoreMoves do
      monopoly.play(andrzej)
    end
  end
end

module Monopoly
  class Game
    def initialize
      @players = []
      @player_moves = {}
    end

    def join(player)
      @players << player
      @player_moves[player] = []
    end

    def play(player)
      raise NoMoreMoves if no_more_moves?(player)
      @player_moves[player] << Move.new
    end

    def no_more_moves?(player)
      @player_moves[player].length >= 3
    end

  end
  class NoMoreMoves < Exception
  end
  class Player

  end

  class Move
  end
end