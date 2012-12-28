 module Monopoly 
  module Board
    class Board
      def initialize(number_of_fields=0)
        @fields = []
        add_fields(number_of_fields)
      end

      def add_field(field)
        @fields << field
      end

      def add_fields(count)
        count.times { add_field(Field.new)}
      end

      def start_field
        @fields.first
      end

      def field_index_of(player)
        @fields.index(player_field(player))
      end

      def player_field(player)
        @fields.detect{|f| f.include?(player)}
      end

      def more_players_on_the_same_field_as?(player)
        player_field(player).players_count > 1
      end

      def set_initial_player_position(player)
        set_player_field(player, start_field)
      end

      def set_player_field(player, field)
        field.add_player(player)
      end

      def set_player_position(player, position)
        @fields[position].add_player(player)
      end

      def move_player_by(player, number)
        old_field = player_field(player)
        old_field.remove_player(player)
        new_field = field_on_with_offset(old_field, number)
        new_field.add_player(player)
      end

      def field_on_with_offset(field, offset)
        @fields[(@fields.index(field) + offset) % @fields.length]
      end

      def put_property_on(position, property)
        @fields[position].put_property(property)
      end

    end
    
    class Field
      attr_reader :property

      def initialize
        @players = []
        @property = nil
      end

      def include?(player)
        @players.include?(player)
      end

      def remove_player(player)
        @players.delete(player)
      end

      def add_player(player)
        @players << player
      end

      def players_count
        @players.count
      end

      def has_any_property?
        @property != nil
      end

      def has_property?(property)
        @property == property
      end

      def put_property(property)
        @property = property
      end

      def owners
        @property.owners
      end

      def points_when_friend_visits
        @property.points_when_friend_visits
      end
    end

    class Property
      attr_reader :points_price, :points_when_friend_visits
      def initialize(name, points_price, points_when_friend_visits)
        @name                      = name
        @points_price              = points_price
        @points_when_friend_visits = points_when_friend_visits
        @owners                    = []
      end

      def add_owner(owner)
        @owners << owner
      end

      def owners
        @owners
      end

    end
  end
end