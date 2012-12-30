#require 'rubygems'
#require 'bundler/setup'
require 'test/unit'
require './monopoly'
require './board'
require './bonuses'
require './dice_roller'
require './player'
require './buying_policies'
require './join_game_rules'
require './make_move_rules'


include Monopoly
include Monopoly::Board
include Monopoly::Bonuses
include Monopoly::BuyingPolicies

class MonopolyTest  < Test::Unit::TestCase

  def test_initial_number_of_moves
    andrzej  = Player.new
    AddInitialNumberOfLifes.new.apply(nil, andrzej)
    assert_equal 3, andrzej.lifes
  end

  def test_make_move_costs_life
    andrzej  = Player.new
    andrzej.add_life
    MoveCostsLife.new.apply(andrzej)
    assert_equal 0, andrzej.lifes
  end

  def test_cant_move_when_no_lifes
    andrzej  = Player.new
    assert_raises NoMoreLifes do
      MoveCostsLife.new.apply(andrzej)
    end
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



end