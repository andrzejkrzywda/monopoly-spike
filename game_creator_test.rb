require 'test/unit'
require './game_creator'

class GameCreatorTest  < Test::Unit::TestCase
  def test_random_dice_roll
    board   = Board.new(16)
    andrzej = Player.new
    monopoly = GameCreator.new.create_default_monopoly_game(board)
    monopoly.join(andrzej)
    monopoly.make_move(andrzej)
    assert_equal(true, 2 <= board.field_index_of(andrzej))
    assert_equal(true, 12 >= board.field_index_of(andrzej))
  end
  
  def test_buying_not_possible
    board   = Board.new(16)
    andrzej = Player.new    
    nike_shop = Property.new("Nike shop", 100, 42)
    board.put_property_on(1, nike_shop)
    board.set_player_position(andrzej, 0)
    monopoly = GameCreator.new.create_default_monopoly_game(board)
    monopoly.join(andrzej)
    assert_raise(NothingToBuyOnThisField) { monopoly.buy(andrzej) }

    board.move_player_by(andrzej, 1)
    assert_raise(CantAfford) { monopoly.buy(andrzej) }

    andrzej.add_property(nike_shop)
    andrzej.add_points(100)

    assert_raise(AlreadyBought) { monopoly.buy(andrzej) }    
  end

  def test_buying
    board   = Board.new(16)
    andrzej = Player.new    
    nike_shop = Property.new("Nike shop", 100, 0)
    board.put_property_on(1, nike_shop)
    monopoly = GameCreator.new.create_default_monopoly_game(board)
    monopoly.join(andrzej)
    board.move_player_by(andrzej, 1)
    andrzej.add_points(120)
    
    monopoly.buy(andrzej)
    assert_equal 20, andrzej.points
    assert_equal [nike_shop], andrzej.properties
    assert_equal [andrzej], nike_shop.owners
  end

end