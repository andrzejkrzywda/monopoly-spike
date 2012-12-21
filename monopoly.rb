module Monopoly
  class Game
    def initialize
      @players = []
      @player_made_moves = {}
      @move_requests = []
      @player_moves = {}
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
      @player_made_moves[player] = []
      @player_moves[player] = []
      3.times { @player_moves[player] << Move.new }
    end

    def play(player)
      raise NoMoreMoves if no_more_moves?(player)
      @player_made_moves[player] << @player_moves[player].shift
    end

    def make_admin(admin)
      @admins << admin
    end

    def no_more_moves?(player)
      @player_moves[player].length == 0
    end

    def give_move(player, friend)
      @player_moves[friend] << Move.new
    end

    def add_start_field
    end
  end
  class NoMoreMoves < Exception
  end

  class NotStarted < Exception
  end

  module MonopolyPlayer
  end
  class Player

  end

  class Move
  end

  class Admin
  end
end