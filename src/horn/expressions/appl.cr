require "./expr"

module Horn
  module Expressions
    class Appl < Expr
      property func : Expr
      property arg : Expr

      def initialize(@func : Expr, @arg : Expr)
      end

      def self.from_list(list : Array(Expr))
        if list.size == 1
          list[0]
        else
          Appl.new(from_list(list[...-1]), list[-1])
        end
      end

      def to_s(io)
        io << "(#{func} #{arg})"
      end

      def inspect(io)
        io << "(#{func} #{arg})"
      end
    end
  end
end
