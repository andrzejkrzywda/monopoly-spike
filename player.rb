module Monopoly
  class Player
    attr_reader :points
    def initialize
      @player_moves = 0
      @points = 0
      @properties = []
    end

    def add_points(amount)
      @points += amount
    end

    def no_more_moves?
      @player_moves == 0
    end

    def take_life
      @player_moves -= 1
    end

    def give_move(friend)
      friend.add_move
    end

    def add_move
      @player_moves += 1
    end

    def pay(points_price)
      raise NotEnoughPointsToPay if points_price > @points
      @points -= points_price
    end

    def add_property(property)
      @properties << property
    end

  end

  class NotEnoughPointsToPay < Exception; end
end