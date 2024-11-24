require "../types/type"

module Horn
  module Expressions
    class Lambda < Expr
      property param : Var
      property param_type : Type
      property body : Expr

      def initialize(@param : Var, @param_type : Type, @body : Expr)
      end

      def to_s(io)
        io << "(λ#{param}:#{param_type}.#{body})"
      end

      def inspect(io)
        io << "(λ#{param}:#{param_type}.#{body})"
      end
    end
  end
end
