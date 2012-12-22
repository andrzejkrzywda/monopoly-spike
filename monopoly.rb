module Monopoly
  class Game
    def initialize
      @players = []
      @admins = []
      @started = false
    end

    def not_started?
      ! @started
    end

    def start
      @started = true
    end

    def join(player)
      raise NotStarted.new if not_started?
      player.extend(MonopolyPlayer)
      @players << player
    end

    def make_admin(admin)
      @admins << admin
    end

    def add_start_field
    end
  end
  
  class NoMoreMoves < Exception
  end

  class NotStarted < Exception
  end

  module MonopolyPlayer
    def self.extended(user)
      @player_moves = []
      @made_moves   = []
      user.instance_variable_set("@player_made_moves", @made_moves)
      user.instance_variable_set("@player_moves",      @player_moves)

      3.times { @player_moves << Move.new }
    end
    def no_more_moves?
      @player_moves.length == 0
    end

    def play
      raise NoMoreMoves if no_more_moves?
      @player_made_moves << @player_moves.shift
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

  class Admin
  end
end