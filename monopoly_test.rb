require 'test/unit'
require './monopoly'
require './board'

include Monopoly
include Monopoly::Board

class MonopolyTest  < Test::Unit::TestCase

  def test_game_limits_moves_to_3
    board = Board.new
    board.add_field(Field.new)
    andrzej  = Person.new
    nthx     = Person.new
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
    board = Board.new
    board.add_fields(16)
    andrzej  = Person.new
    nthx     = Person.new
    monopoly = MonopolyPlayGameUseCase.new([andrzej, nthx], board)
    monopoly.start_game
    monopoly.make_move(nthx, 4)
    monopoly.make_move(andrzej, 4)
    assert_equal(50, monopoly.all_points(andrzej))
    assert_equal(0, monopoly.all_points(nthx))
  end

  def test_players_dont_get_points_when_they_dont_meet_friends
    board   = Board.new
    board.add_fields(16)
    andrzej = Person.new
    nthx    = Person.new
    monopoly = MonopolyPlayGameUseCase.new([andrzej, nthx], board)
    monopoly.start_game
    monopoly.make_move(nthx, 10)
    monopoly.make_move(andrzej, 4)
    assert_equal(0, monopoly.all_points(andrzej))
    assert_equal(0, monopoly.all_points(nthx))
  end
    def test_random_dice_roll
    board   = Board.new
    board.add_fields(16)
    andrzej = Person.new
    monopoly = MonopolyPlayGameUseCase.new([andrzej], board)
    monopoly.start_game
    monopoly.make_move(andrzej)
    assert_equal(true, 2 <= board.field_index_of(andrzej))
    assert_equal(true, 12 >= board.field_index_of(andrzej))

  end

end