module Monopoly
  class GameCreator
    def create_default_monopoly_game(players = [], board = Board.new(16))
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