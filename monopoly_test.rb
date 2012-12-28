require 'test/unit'
require './monopoly'
require './board'
require './bonuses'
require './dice_roller'
require './player'

include Monopoly
include Monopoly::Board
include Monopoly::Bonuses

class MonopolyTest  < Test::Unit::TestCase

  def test_game_limits_moves_to_3
    board = Board.new
    board.add_field(Field.new)
    andrzej  = Player.new
    nthx     = Player.new
    monopoly = MonopolyPlayGameUseCase.new([andrzej, nthx], board)
    monopoly.start_game

    3.times { monopoly.make_move(andrzej, 0) }
    assert_raises NoMoreMoves do
      monopoly.make_move(andrzej, 0)
    end

    monopoly.give_move(nthx, andrzej)
    monopoly.make_move(andrzej, 0)
  end

  def test_players_get_points_when_they_meet_friends
    board   = Board.new(16)
    andrzej = Player.new
    nthx    = Player.new
    board.set_player_position(andrzej, 0)
    board.set_player_position(nthx, 0)

    BonusForMeetingFriendsAtTheSameField.new.apply(board, andrzej)

    assert_equal(50, andrzej.points)
    assert_equal(0, nthx.points)
  end

  def test_players_dont_get_points_when_they_dont_meet_friends
    board   = Board.new(16)
    andrzej = Player.new
    nthx    = Player.new
    board.set_player_position(andrzej, 0)
    board.set_player_position(nthx, 10)

    BonusForMeetingFriendsAtTheSameField.new.apply(board, andrzej)

    assert_equal(0, andrzej.points)
    assert_equal(0, nthx.points)
  end
  
  def test_random_dice_roll
    board   = Board.new(16)
    andrzej = Player.new
    monopoly = MonopolyPlayGameUseCase.new([andrzej], board)
    monopoly.start_game
    monopoly.make_move(andrzej)
    assert_equal(true, 2 <= board.field_index_of(andrzej))
    assert_equal(true, 12 >= board.field_index_of(andrzej))
  end

  def test_assign_properties_to_fields
    board     = Board.new(16)
    andrzej   = Player.new
    nthx      = Player.new
    nike_shop = Property.new("Nike shop", 100, 42)
    board.put_property_on(1, nike_shop)
    nike_shop.add_owner(andrzej)

    board.set_player_position(nthx, 1)

    GiveBonusPointsToFriendsWhenVisitingTheirProperty.new.apply(board, nthx)

    assert_equal(42, andrzej.points)
    assert_equal(0, nthx.points)
  end

  def test_buying
    board   = Board.new(16)
    andrzej = Player.new    
    nike_shop = Property.new("Nike shop", 100, 42)
    board.put_property_on(1, nike_shop)
    board.set_player_position(andrzej, 0)
    monopoly = MonopolyPlayGameUseCase.new([andrzej], board)
    assert_raise(NothingToBuyOnThisField) { monopoly.buy(andrzej) }

    board.move_player_by(andrzej, 1)
    assert_raise(CantAfford) { monopoly.buy(andrzej) }
  end

end