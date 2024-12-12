require "./value"
require "../expressions/expr"

module Horn
  module Values
    class Map < Value
      property values

      def initialize(@values : Hash(Expr | Value, Value))
      end

      def initialize
        @values = Hash(Expr | Value, Value).new
      end

      def to_s(io)
        values.to_s(io)
      end

      def inspect(io)
        values.inspect(io)
      end

      def [](key : Expr | Value)
        values[key]
      end

      def []=(key : Expr | Value, value : Value)
        values[key] = value
      end

      def hash(hasher)
        values.hash(hasher)
      end

      def ==(other)
        return false unless other.is_a?(Map)
        values == other.values
      end
    end
  end
end
