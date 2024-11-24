require "./expr"

module Horn
  module Expressions
    class Exists < Expr
      property var : Var
      property var_type : Type
      property expr : Expr

      def initialize(@var : Var, @var_type : Type, @expr : Expr)
      end

      def to_s(io)
        io << "(∃#{var}:#{var_type}.#{expr})"
      end

      def inspect(io)
        io << "(∃#{var}:#{var_type}.#{expr})"
      end
    end
  end
end
