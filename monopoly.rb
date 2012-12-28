module Monopoly
  
  class DiceRoller
    def roll_2
      (1..6).to_a.shuffle[0] + (1..6).to_a.shuffle[0]
    end
  end

  class BonusForMeetingFriendsAtTheSameField
    def apply(board, player)
      if board.more_players_on_the_same_field_as?(player)
        player.add_points(50)
      end
    end
  end

  class GiveBonusPointsToFriendsWhenVisitingTheirProperty
    def apply(board, player)
      target_field = board.player_field(player)
      if target_field.has_any_property?
        for player in target_field.owners do
          player.add_points(target_field.points_when_friend_visits)
        end
      end
    end
  end

  class MonopolyPlayGameUseCase
    def initialize(players, board, make_move_policies=[])
      @players = players
      @players.each { |player| player.extend(Player)}
      @board = board
      @make_move_policies = make_move_policies
        
    end

    def start_game
      @players.each { |player| @board.set_initial_player_position(player) }
      @players.each { |player| 3.times { player.add_move } }
    end

    def make_move(player, dice_roll = DiceRoller.new.roll_2 )
      raise NoMoreMoves if player.no_more_moves?
      player.take_life
      @board.move_player_by(player, dice_roll)
      @make_move_policies.each {|p| p.apply(@board, player)}
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

  class NoMoreMoves < Exception
  end

  class NotEnoughPointsToPay < Exception
  end

  class CantBuyPropertyWithoutBeingOnTheField < Exception
  end



  module Player

    def player_moves
      @player_moves ||= []      
    end

    def points
      @points ||= 0
    end

    def add_points(amount)
      @points = points + amount
    end

    def no_more_moves?
      player_moves.length == 0
    end

    def take_life
      player_moves.shift
    end

    def give_move(friend)
      friend.add_move
    end

    def add_move
      player_moves << Move.new
    end

    def pay(points_price)
      raise NotEnoughPointsToPay if points_price > @points
      @points -= points_price
    end

    def add_property(property)
      @properties ||= []
      @properties << property
    end

  end

  class Person
  end

  class Move
  end


end