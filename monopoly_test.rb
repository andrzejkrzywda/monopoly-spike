require 'test/unit'
require './monopoly'

include Monopoly

class MonopolyTest  < Test::Unit::TestCase
  def new_monopoly_game
    monopoly = Game.new
    monopoly.start()
    return monopoly
  end

  def new_player
    Player.new
  end

  def test_cant_join_if_not_started
    monopoly = Game.new
    assert_raises NotStarted do 
      monopoly.join(new_player) 
    end
  end

  def test_game_allows_many_players
    monopoly = new_monopoly_game
    andrzej  = new_player
    nthx     = new_player

    monopoly.join(andrzej)
    monopoly.join(nthx)
    andrzej.play
    nthx.play
    nthx.play
  end

  def test_game_limits_moves_to_3
    monopoly = new_monopoly_game
    andrzej  = new_player
    monopoly.join(andrzej)

    3.times { andrzej.play }
    assert_raises NoMoreMoves do
      andrzej.play
    end
  end
  def test_asking_for_moves
    monopoly = new_monopoly_game
    andrzej  = new_player
    nthx     = new_player

    monopoly.join(andrzej)
    monopoly.join(nthx)

    3.times { andrzej.play }
    nthx.give_move(andrzej)

    andrzej.play
  end

  def test_admin
    monopoly = new_monopoly_game
    admin = Admin.new
    monopoly.make_admin(admin)
  end

  def test_player_can_move_on_fields
    monopoly = new_monopoly_game
    andrzej  = new_player
    nthx     = new_player
    monopoly.join(andrzej)
    monopoly.join(nthx)

    admin = Admin.new
    monopoly.make_admin(admin)
    field_0 = Field.new
    field_1 = Field.new
    field_2 = Field.new
    field_3 = Field.new
    assert_equal(field_0, admin.player_field(andrzej))
    andrzej.play(1)
    assert_equal(field_1, admin.player_field(andrzej))
    andrzej.play(3)
    assert_equal(field_0, admin.player_field(andrzej))

  end
end