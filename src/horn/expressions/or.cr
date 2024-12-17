require "./expr"

module Horn
  module Expressions
    class Or < Expr
      getter left : Expr
      getter right : Expr

      def initialize(@left : Expr, @right : Expr)
      end

      def self.from_list(list : Array(Expr))
        if list.size == 1
          list[0]
        else
          Or.new(list[0], from_list(list[1..]))
        end
      end

      def children
        [left, right]
      end

      def to_s(io)
        io << "(#{left} ∨ #{right})"
      end

      def inspect(io)
        io << "(#{left} ∨ #{right})"
      end
    end
  end
end
