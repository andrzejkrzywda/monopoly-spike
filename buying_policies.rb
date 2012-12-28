module Monopoly
  module BuyingPolicies
    class NothingToBuyOnThisField < Exception; end
    class CantAfford < Exception; end
    class AlreadyBought < Exception; end

    class NothingToBuyOnThisFieldPolicy
      def apply(player, field)
        raise NothingToBuyOnThisField if ! field.has_any_property?
      end
    end

    class AlreadyBoughtPolicy
      def apply(player, field)
        raise AlreadyBought if player.owns?(field.property)
      end
    end

    class CantAffordPolicy
      def apply(player, field)
        raise CantAfford if field.property.points_price > player.points
      end
    end
  end
end