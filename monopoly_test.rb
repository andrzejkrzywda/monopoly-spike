require 'test/unit'
require './monopoly'

include Monopoly

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



  def test_make_move
    board = Board.new
    field_0 = Field.new
    field_1 = Field.new
    field_2 = Field.new
    field_3 = Field.new
    board.add_field(field_0)
    board.add_field(field_1)
    board.add_field(field_2)
    board.add_field(field_3)

    andrzej  = Player.new

    monopoly = MonopolyPlayGameUseCase.new([andrzej], board)
    monopoly.start_game
    assert_on_field(board, andrzej, field_0)

    monopoly.make_move(andrzej, 1)
    assert_on_field(board, andrzej, field_1)
    
    monopoly.make_move(andrzej, 3)
    assert_on_field(board, andrzej, field_0)
  end

  def assert_on_field(board, player, field)
    assert_equal(field, board.player_field(player), "wrong field")
  end
end