module Monopoly
  module Bonuses    
    class BonusForMeetingFriendsAtTheSameField
      def apply(board, player)
        if board.more_players_on_the_same_field_as?(player)
          player.add_points(50)
        end
      end
    end

    class GiveBonusPointsToFriendsWhenVisitingTheirProperty
      def apply(board, player)
        target_field = board.player_field(player)
        if target_field.has_any_property?
          for player in target_field.owners do
            player.add_points(target_field.points_when_friend_visits)
          end
        end
      end
    end
  end
end