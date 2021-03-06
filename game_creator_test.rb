require 'test/unit'
require './game_creator'

class GameCreatorTest  < Test::Unit::TestCase

  def test_fake_dice_roll
    board   = Board.new(16)
    andrzej = Player.new
    cheater_dice_roller = CheaterDiceRoller.new
    cheater_dice_roller.next_roll_will_be(4)
    monopoly = GameCreator.new.create_default_monopoly_game(board, cheater_dice_roller)
    monopoly.join(andrzej)
    monopoly.make_move(andrzej)
    assert_equal(4, board.field_index_of(andrzej))
  end

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
    cheater_dice_roller = CheaterDiceRoller.new
    nike_shop = Property.new("Nike shop", 100, 42)
    board.put_property_on(1, nike_shop)

    monopoly = GameCreator.new.create_default_monopoly_game(board, cheater_dice_roller)
    monopoly.join(andrzej)
    assert_raise(NothingToBuyOnThisField) { monopoly.buy(andrzej) }

    cheater_dice_roller.next_roll_will_be(1)
    monopoly.make_move(andrzej)
    assert_raise(CantAfford) { monopoly.buy(andrzej) }

    andrzej.add_property(nike_shop)
    andrzej.add_points(100)

    assert_raise(AlreadyBought) { monopoly.buy(andrzej) }    
  end

  def test_buying
    board   = Board.new(16)
    andrzej = Player.new    
    cheater_dice_roller = CheaterDiceRoller.new
    nike_shop = Property.new("Nike shop", 100, 0)
    board.put_property_on(1, nike_shop)
    monopoly = GameCreator.new.create_default_monopoly_game(board, cheater_dice_roller)
    monopoly.join(andrzej)
    cheater_dice_roller.next_roll_will_be(1)
    monopoly.make_move(andrzej)
    andrzej.add_points(120)
    
    monopoly.buy(andrzej)
    assert_equal 20, andrzej.points
    assert_equal [nike_shop], andrzej.properties
    assert_equal [andrzej], nike_shop.owners
  end

end