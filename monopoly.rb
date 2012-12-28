module Monopoly  
  class MonopolyPlayGameUseCase
    def initialize(players, board, after_make_move_policies=[], buying_policies=[])
      @players = players
      @board = board
      @after_make_move_policies = after_make_move_policies
      @buying_policies = buying_policies
    end

    def start_game
      @players.each { |player| @board.set_initial_player_position(player) }
      @players.each { |player| 3.times { player.add_move } }
    end

    def make_move(player, dice_roll = DiceRoller.new.roll_2 )
      raise NoMoreMoves if player.no_more_moves?
      player.take_life
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

    def give_move(from_player, to_player)
      to_player.add_move
    end
  end

  class NoMoreMoves < Exception; end

end