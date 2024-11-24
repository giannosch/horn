require "./expr"

module Horn
  module Expressions
    class And < Expr
      property left : Expr
      property right : Expr

      def initialize(@left : Expr, @right : Expr)
      end

      def self.from_list(list : Array(Expr))
        if list.size == 1
          list[0]
        else
          And.new(list[0], from_list(list[1..]))
        end
      end

      def to_s(io)
        io << "(#{left} ∧ #{right})"
      end

      def inspect(io)
        io << "(#{left} ∧ #{right})"
      end
    end
  end
end
