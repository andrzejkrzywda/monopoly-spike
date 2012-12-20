module Monopoly
  class Game
    def initialize
      @players = []
      @player_moves = {}
    end

    def join(player)
      @players << player
      @player_moves[player] = []
    end

    def play(player)
      raise NoMoreMoves if no_more_moves?(player)
      @player_moves[player] << Move.new
    end

    def no_more_moves?(player)
      @player_moves[player].length >= 3
    end

  end
  class NoMoreMoves < Exception
  end
  class Player

  end

  class Move
  end
end