require "./expr"

module Horn
  module Expressions
    class Forall < Expr
      property var : Var
      property var_type : Type
      property expr : Expr

      def initialize(@var : Var, @var_type : Type, @expr : Expr)
      end

      def children
        [expr]
      end

      def bounded_var
        var
      end

      def to_s(io)
        io << "(∀#{var}:#{var_type}.#{expr})"
      end

      def inspect(io)
        io << "(∀#{var}:#{var_type}.#{expr})"
      end
    end
  end
end
