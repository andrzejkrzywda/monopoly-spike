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
      game = MonopolyPlayGameUseCase.new(board, 
                                          default_join_game_rules,
                                          default_before_make_move_rules,
                                          default_after_make_move_policies, 
                                          default_buying_policies)
      players.each {|player| game.join(player)}
      Aspect.new :before, methods: [:join], for_objects: [game] do |jp, game, player|
        AddInitialNumberOfLifes.new.apply(nil, player)
      end
      return game
    end

    def default_join_game_rules
      [
        #AddInitialNumberOfLifes.new(3),
        PutPlayerOnBoardInitialField.new
      ]
    end

    def default_before_make_move_rules
      [MoveCostsLife.new]
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