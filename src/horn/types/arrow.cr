require "./type"

module Horn
  module Types
    class Arrow < Type
      property left : Type
      property right : Type

      def initialize(@left : Type, @right : Type)
      end

      def to_s(io)
        io << "(#{left} -> #{right})"
      end

      def inspect(io)
        io << "(#{left} -> #{right})"
      end

      def ==(other)
        return false unless other.is_a?(Arrow)
        left == other.left && right == other.right
      end
    end
  end
end
