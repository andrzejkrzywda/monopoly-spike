module Monopoly
  
  class DiceRoll
    def roll_2
      (1..6).to_a.shuffle[0] + (1..6).to_a.shuffle[0]
    end
  end

  class MonopolyPlayGameUseCase
    def initialize(players, board)
      @players = players
      @players.each { |player| player.extend(Player)}
      @board = board
    end

    def start_game
      @players.each { |player| @board.set_initial_player_position(player) }
      @players.each { |player| 3.times { player.add_move } }
    end

    def make_move(player, dice_roll = DiceRoll.new.roll_2 )
      raise NoMoreMoves if player.no_more_moves?
      player.take_life
      @board.move_player_by(player, dice_roll)

      if @board.more_players_on_the_same_field_as?(player)
        player.add_points(50)
      end
    end

    def give_move(from_player, to_player)
      to_player.add_move
    end

    def all_points(player)
      player.points
    end
  end

  class NoMoreMoves < Exception
  end


  module Player

    def player_moves
      @player_moves ||= []      
    end

    def points
      @points ||= 0
    end

    def add_points(amount)
      @points = points + 50
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

  end

  class Person
  end

  class Move
  end


end