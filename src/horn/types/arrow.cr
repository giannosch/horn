require "./type"

module Horn
  module Types
    class Arrow
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
    end
  end
end
