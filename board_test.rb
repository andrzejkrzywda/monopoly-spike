require 'test/unit'
require './board'

include Monopoly::Board

class BoardTest  < Test::Unit::TestCase

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

    andrzej  = Object.new
    board.set_initial_player_position(andrzej)
    assert_on_field(board, andrzej, field_0)

    board.move_player_by(andrzej, 1)
    assert_on_field(board, andrzej, field_1)
    
    board.move_player_by(andrzej, 3)
    assert_on_field(board, andrzej, field_0)
  end

  def assert_on_field(board, player, field)
    assert_equal(field, board.player_field(player), "wrong field")
  end
end