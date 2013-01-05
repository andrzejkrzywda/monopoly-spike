module Monopoly
  class DiceRoller
    def roll_2
      (1..6).to_a.shuffle[0] + (1..6).to_a.shuffle[0]
    end
  end

  class CheaterDiceRoller
    def next_roll_will_be(value)
      @next_roll = value
    end
    def roll_2
      @next_roll
    end
  end
end