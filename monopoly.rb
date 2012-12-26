module Monopoly
  class MonopolyPlayGameUseCase
    def initialize(players, board)
      @players = players
      @players.each { |player| player.extend(MonopolyPlayer)}
      @board = board
    end

    def start_game
      @players.each { |player| @board.set_initial_player_position(player) }
      @players.each { |player| 3.times { player.add_move } }
    end

    def make_move(player, dice_roll=0)
      raise NoMoreMoves if player.no_more_moves?
      player.take_life
      @board.move_player_by(player, dice_roll)
    end

    def give_move(from_player, to_player)
      to_player.add_move
    end
  end

  class NoMoreMoves < Exception
  end


  module MonopolyPlayer
    def self.extended(user)
      @player_moves = []
      user.instance_variable_set("@player_moves",      @player_moves)

      
    end

    def no_more_moves?
      @player_moves.length == 0
    end

    def take_life
      @player_moves.shift
    end

    def play(dice_roll=0)
      raise NoMoreMoves if no_more_moves?
      take_life
      @game.move_player_by(self, dice_roll)
    end

    def give_move(friend)
      friend.add_move
    end

    def add_move
      @player_moves << Move.new
    end
  end

  class Player
  end

  class Move
  end


end