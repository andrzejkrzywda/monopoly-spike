module Monopoly
  class DiceRoller
    def roll_2
      (1..6).to_a.shuffle[0] + (1..6).to_a.shuffle[0]
    end
  end
end