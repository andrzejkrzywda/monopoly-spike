module Monopoly  
  class MonopolyPlayGameUseCase
    def initialize(players, board, after_make_move_policies=[])
      @players = players
      @board = board
      @after_make_move_policies = after_make_move_policies
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
      NothingToBuyOnThisFieldPolicy.new.apply(@board, player)
      raise AlreadyBought if player.owns?(@board.player_field(player).property)
      raise CantAfford if @board.player_field(player).property.points_price > player.points
      player.pay(property.points_price)
      player.add_property(property)
      property.add_owner(player)
    end

    def give_move(from_player, to_player)
      to_player.add_move
    end
  end

  class NoMoreMoves < Exception; end
  class CantBuyPropertyWithoutBeingOnTheField < Exception; end
  class NothingToBuyOnThisField < Exception; end
  class CantAfford < Exception; end

  class NothingToBuyOnThisFieldPolicy
    def apply(board, player)
      raise NothingToBuyOnThisField if ! board.player_field(player).has_any_property?
    end
  end
end