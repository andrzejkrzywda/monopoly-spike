module Monopoly 

  class MonopolyPlayGameUseCase
    def initialize(board, dice_roller)
      @dice_roller = dice_roller
      @board = board
      @players = []
    end

    def join(player)
      @players << player
    end

    def make_move(player)
      dice_roll = @dice_roller.roll_2
      @board.move_player_by(player, dice_roll)
    end

    def buy(player)
      current_field = @board.player_field(player)
      property = current_field.property
      player.pay(property.points_price)
      player.add_property(property)
      property.add_owner(player)
    end

    def give_life_from_player(from_player, to_player)
      to_player.add_life
    end
  end
end