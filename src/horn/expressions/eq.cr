require "./expr"

module Horn
  module Expressions
    class Eq < Expr
      property left : Expr
      property right : Expr

      def initialize(@left : Expr, @right : Expr)
      end

      def to_s(io)
        io << "(#{left} ≈ #{right})"
      end

      def inspect(io)
        io << "(#{left} ≈ #{right})"
      end
    end
  end
end
