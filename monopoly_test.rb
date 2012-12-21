require 'test/unit'
require './monopoly'

include Monopoly

class MonopolyTest  < Test::Unit::TestCase
  def new_monopoly_game
    Game.new
  end

  def new_player
    Player.new
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

    3.times { monopoly.play(andrzej) }
    assert_raises NoMoreMoves do
      monopoly.play(andrzej)
    end
  end
  def test_asking_for_moves
    monopoly = new_monopoly_game
    andrzej  = new_player
    nthx     = new_player

    monopoly.join(andrzej)
    monopoly.join(nthx)

    3.times { monopoly.play(andrzej) }
    monopoly.give_move(nthx, andrzej)

    monopoly.play(andrzej)
  end

  def test_admin
    monopoly = new_monopoly_game
    admin = new Admin()
    monopoly.make_admin(admin)

  end
end