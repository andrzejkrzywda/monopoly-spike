module Monopoly
  class Player
    attr_reader :points
    def initialize
      @lifes = 0
      @points = 0
      @properties = []
    end

    def add_points(amount)
      @points += amount
    end

    def no_more_lifes?
      @lifes == 0
    end

    def take_life
      @lifes -= 1
    end

    def give_life(friend)
      friend.add_life
    end

    def add_life
      @lifes += 1
    end

    def pay(points_price)
      @points -= points_price
    end

    def add_property(property)
      @properties << property
    end

    def owns?(property)
      @properties.include?(property)
    end

  end
end