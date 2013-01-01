require 'rubygems'
require 'bundler/setup'
require 'aquarium'
require './monopoly'
require './board'
require './bonuses'
require './dice_roller'
require './player'
require './buying_policies'
require './join_game_rules'
require './make_move_rules'

include Monopoly
include Monopoly::Board
include Monopoly::Bonuses
include Monopoly::BuyingPolicies

include Aquarium::Aspects

def before(object, method, &block)
  Aspect.new :before, methods: [method], for_objects: [object] do |*args|
    block.call(args)
  end
end
def after(object, method, &block)
  Aspect.new :after, methods: [method], for_objects: [object] do |*args|
    block.call(args)
  end
end
module Monopoly
  class GameCreator
    def create_default_monopoly_game(board = Board::Board.new(16))
      game = MonopolyPlayGameUseCase.new(board)
      
      default_join_game_rules(game, board)
      default_before_make_move_rules(game)
      default_after_make_move_policies(game, board)
      default_buying_policies(game, board)
      
      return game
    end

    def default_join_game_rules(game, board)
      before game, :join do |jp, game, player|
        AddInitialNumberOfLifes.new.apply(board, player)
        PutPlayerOnBoardInitialField.new.apply(board, player)
      end
    end

    def default_before_make_move_rules(game)
      before game, :make_move do |jp, game, player|
        MoveCostsLife.new.apply(player)
      end
    end

    def default_after_make_move_policies(game, board)
      after game, :make_move do |jp, game, player|
        BonusForMeetingFriendsAtTheSameField.new.apply(board, player)
        GiveBonusPointsToFriendsWhenVisitingTheirProperty.new.apply(board, player)
      end
    end

    def default_buying_policies(game, board)
      before game, :buy do |jp, game, player|
        field = board.player_field(player)
        NothingToBuyOnThisFieldPolicy.new.apply(player, field)
        AlreadyBoughtPolicy.new.apply(player, field)
        CantAffordPolicy.new.apply(player, field)
      end
    end
  end
  
end