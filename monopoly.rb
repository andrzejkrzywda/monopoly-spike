module Monopoly
  class MonopolyPlayGameUseCase
    def initialize(players, board)
      @players = players
      @players.each { |player| player.extend(MonopolyPlayer)}
      @board = board
    end

    def start_game
      @players.each { |player| @board.set_initial_player_position(player) }
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

      3.times { @player_moves << Move.new }
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
  class Board
    def initialize
      @player_position = {}
      @fields = []
    end

    def add_field(field)
      @fields << field
    end

    def start_field
      @fields[0]
    end

    def player_field(player)
      @player_position[player]
    end

    def set_initial_player_position(player)
      set_player_position(player, start_field)
    end

    def set_player_position(player, field)
      @player_position[player] = field
    end

    def move_player_by(player, number)
      @player_position[player] = field_on_with_offset(@player_position[player], number)
    end

    def field_on_with_offset(field, offset)
      @fields[(@fields.index(field) + offset) % @fields.length]
    end

  end
 
  class Player

  end

  class Move
  end

  class Field
  end


end