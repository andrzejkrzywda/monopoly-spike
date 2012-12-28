require './monopoly'
require './board'
require './bonuses'
require './dice_roller'
require './player'
require './buying_policies'

include Monopoly
include Monopoly::Board
include Monopoly::Bonuses
include Monopoly::BuyingPolicies

module Monopoly
  class GameCreator
    def create_default_monopoly_game(players = [], board = Board::Board.new(16))
      MonopolyPlayGameUseCase.new(players, 
                                  board, 
                                  default_after_make_move_policies, 
                                  default_buying_policies)
    end

    def default_after_make_move_policies
      [
        BonusForMeetingFriendsAtTheSameField.new,
        GiveBonusPointsToFriendsWhenVisitingTheirProperty.new
      ]
    end

    def default_buying_policies
      [
        NothingToBuyOnThisFieldPolicy.new,
        AlreadyBoughtPolicy.new,
        CantAffordPolicy.new
      ]
    end
  end
  
end