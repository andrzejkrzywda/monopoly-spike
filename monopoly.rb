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

    def buy(player, property)
      begin
        raise CantBuyPropertyWithoutBeingOnTheField if ! @board.player_field(player).has_property?(property)
        player.pay(property.points_price)
        player.add_property(property)
        property.add_owner(player)
      rescue NotEnoughPointsToPay
        raise CantAfford
      end
    end

    def give_move(from_player, to_player)
      to_player.add_move
    end
  end

  class NoMoreMoves < Exception; end
  class NotEnoughPointsToPay < Exception; end
  class CantBuyPropertyWithoutBeingOnTheField < Exception; end

  class Player
    attr_reader :points
    def initialize
      @player_moves = []
      @points = 0
      @properties = []
    end

    def add_points(amount)
      @points = points + amount
    end

    def no_more_moves?
      @player_moves.length == 0
    end

    def take_life
      @player_moves.shift
    end

    def give_move(friend)
      friend.add_move
    end

    def add_move
      @player_moves << Move.new
    end

    def pay(points_price)
      raise NotEnoughPointsToPay if points_price > @points
      @points -= points_price
    end

    def add_property(property)
      @properties << property
    end

  end

  class Move
  end
end