module Monopoly 

  class MonopolyPlayGameUseCase
    def initialize(board, join_game_rules=[], after_make_move_policies=[], buying_policies=[])
      @dice_roller = DiceRoller.new
      @board = board
      @join_game_rules = join_game_rules
      @after_make_move_policies = after_make_move_policies
      @buying_policies = buying_policies
    end

    def join(player)
      @join_game_rules.each {|rule| rule.apply(@board, player)}
    end

    def make_move(player)
      raise NoMoreLifes if player.no_more_lifes?
      player.take_life
      dice_roll = @dice_roller.roll_2
      @board.move_player_by(player, dice_roll)
      @after_make_move_policies.each {|p| p.apply(@board, player)}
    end

    def buy(player)
      current_field = @board.player_field(player)
      @buying_policies.each {|policy| policy.apply(player, current_field)}

      player.pay(property.points_price)
      player.add_property(property)
      property.add_owner(player)
    end

    def give_life(from_player, to_player)
      to_player.add_life
    end
  end

  class NoMoreLifes < Exception; end

end