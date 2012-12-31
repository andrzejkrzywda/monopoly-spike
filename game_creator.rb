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

module Monopoly
  class GameCreator
    def create_default_monopoly_game(players = [], board = Board::Board.new(16))
      game = MonopolyPlayGameUseCase.new(board)
      
      default_join_game_rules(game, board)
      default_before_make_move_rules(game)
      default_after_make_move_policies(game, board)
      default_buying_policies(game, board)
      

      players.each {|player| game.join(player)}

      return game
    end

    def default_join_game_rules(game, board)
      Aspect.new :before, methods: [:join], for_objects: [game] do |jp, game, player|
        AddInitialNumberOfLifes.new.apply(board, player)
        PutPlayerOnBoardInitialField.new.apply(board, player)
      end
    end

    def default_before_make_move_rules(game)
      Aspect.new :before, methods: [:make_move], for_objects: [game] do |jp, game, player|
        MoveCostsLife.new.apply(player)
      end
    end

    def default_after_make_move_policies(game, board)
      Aspect.new :after, methods: [:make_move], for_objects: [game] do |jp, game, player|
        BonusForMeetingFriendsAtTheSameField.new.apply(board, player)
        GiveBonusPointsToFriendsWhenVisitingTheirProperty.new.apply(board, player)
      end
    end

    def default_buying_policies(game, board)
      Aspect.new :before, methods: [:buy], for_objects: [game] do |jp, game, player|
        field = board.player_field(player)
        NothingToBuyOnThisFieldPolicy.new.apply(player, field)
        AlreadyBoughtPolicy.new.apply(player, field)
        CantAffordPolicy.new.apply(player, field)
      end
    end
  end
  
end