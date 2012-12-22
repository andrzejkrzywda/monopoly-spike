module Monopoly
  class Game
    def initialize
      @players = []
      @admins = []
      @fields = []
      @started = false
      @player_position = {}
    end

    def not_started?
      ! @started
    end

    def start
      @started = true
    end

    def start_field
      @fields[0]
    end

    def player_field(player)
      @player_position[player]
    end

    def join(player)
      raise NotStarted.new if not_started?
      player.extend(MonopolyPlayer)
      player.in_game(self)
      @player_position[player] = start_field
      @players << player
    end

    def move_player_by(player, number)
      @player_position[player] = field_on_with_offset(@player_position[player], number)
    end

    def field_on_with_offset(field, offset)
      @fields[(@fields.index(field) + offset) % @fields.length]
    end

    def make_admin(admin)
      @admins << admin
      admin.manages(self)
    end

    def add_field(field)
      @fields << field
    end
  end

  class NoMoreMoves < Exception
  end

  class NotStarted < Exception
  end

  module MonopolyPlayer
    def self.extended(user)
      @player_moves = []
      user.instance_variable_set("@player_moves",      @player_moves)

      3.times { @player_moves << Move.new }
    end

    def in_game(game)
      @game = game
    end

    def no_more_moves?
      @player_moves.length == 0
    end

    def play(dice_roll=0)
      raise NoMoreMoves if no_more_moves?
      @player_moves.shift
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

  class Field
  end

  class Admin
    def manages(game)
      @game = game
    end
    def add_field(field)
      @game.add_field(field)
    end
  end
end