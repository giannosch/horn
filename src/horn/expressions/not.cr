require "./expr"

module Horn
  module Expressions
    class Not < Expr
      property expr : Expr

      def initialize(@expr : Expr)
      end

      def to_s(io)
        io << "¬#{expr}"
      end

      def inspect(io)
        io << "¬#{expr}"
      end
    end
  end
end
