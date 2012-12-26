require 'test/unit'
require './monopoly'
require './board'

include Monopoly
include Monopoly::Board

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

  def TODO_test_players_get_points_when_they_meet_friends
    board = Board.new
    board.add_fields(16)
    andrzej  = Player.new
    nthx     = Player.new
    monopoly = MonopolyPlayGameUseCase.new([andrzej, nthx], board)
    monopoly.start_game
    monopoly.make_move(nthx, 4)
    monopoly.make_move(andrzej, 4)
    assert_equal(50, monopoly.all_points(andrzej))

  end

end