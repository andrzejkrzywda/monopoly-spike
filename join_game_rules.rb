module Monopoly
  class PutPlayerOnBoardInitialField
    def apply(board, player)
      board.set_initial_player_position(player)
    end
  end

  class AddInitialNumberOfLifes
    def initialize(number_of_lifes=3)
      @number_of_lifes = number_of_lifes
    end

    def apply(board, player)
      3.times { player.add_move } 
    end
  end
end