require "../types/type"

module Horn
  module Expressions
    class Lambda < Expr
      property param : Var
      property param_type : Type?
      property body : Expr

      def initialize(@param : Var, @param_type : Type?, @body : Expr)
      end

      def children
        [body]
      end

      def bounded_var
        param
      end

      def to_s(io)
        if param_type
          io << "(λ#{param}:#{param_type}.#{body})"
        else
          io << "(λ#{param}.#{body})"
        end
      end

      def inspect(io)
        to_s(io)
      end
    end
  end
end
