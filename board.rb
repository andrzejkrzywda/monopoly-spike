 module Monopoly 
  module Board
    class Board
      def initialize
        @player_position = {}
        @fields = []
      end

      def add_field(field)
        @fields << field
      end

      def start_field
        @fields[0]
      end

      def player_field(player)
        @player_position[player]
      end

      def set_initial_player_position(player)
        set_player_position(player, start_field)
      end

      def set_player_position(player, field)
        @player_position[player] = field
      end

      def move_player_by(player, number)
        @player_position[player] = field_on_with_offset(@player_position[player], number)
      end

      def field_on_with_offset(field, offset)
        @fields[(@fields.index(field) + offset) % @fields.length]
      end

    end
    
    class Field
    end
 
  end
end