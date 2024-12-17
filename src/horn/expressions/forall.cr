require "./expr"

module Horn
  module Expressions
    class Forall < Expr
      getter var : Var
      getter var_type : Type
      getter expr : Expr

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
