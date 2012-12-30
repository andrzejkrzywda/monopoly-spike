module Monopoly
  class MoveCostsLife
    def apply(player)
      raise NoMoreLifes if player.no_more_lifes?
      player.take_life
    end
  end


  class NoMoreLifes < Exception; end
end