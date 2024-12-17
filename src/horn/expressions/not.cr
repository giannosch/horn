require "./expr"

module Horn
  module Expressions
    class Not < Expr
      getter expr : Expr

      def initialize(@expr : Expr)
      end

      def children
        [expr]
      end

      def to_s(io)
        io << "¬#{expr}"
      end

      def inspect(io)
        io << "¬#{expr}"
      end

      def hash(hasher)
        {self.class, expr}.hash(hasher)
      end

      def ==(other)
        return false unless other.is_a?(Not)
        expr == other.expr
      end
    end
  end
end
