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

      def hash(hasher)
        {self.class, left.hash ^ right.hash}.hash(hasher)
      end

      def ==(other)
        return false unless other.is_a?(Eq)
        (left == other.left && right == other.right) || (left == other.right && right == other.left)
      end
    end
  end
end
