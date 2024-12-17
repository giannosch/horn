require "./expr"

module Horn
  module Expressions
    class Appl < Expr
      getter func : Expr
      getter arg : Expr

      def initialize(@func : Expr, @arg : Expr)
      end

      def self.from_list(list : Array(Expr))
        if list.size == 1
          list[0]
        else
          Appl.new(from_list(list[...-1]), list[-1])
        end
      end

      def children
        [func, arg]
      end

      def to_s(io)
        io << "(#{func} #{arg})"
      end

      def inspect(io)
        io << "(#{func} #{arg})"
      end

      def hash(hasher)
        {self.class, func, arg}.hash(hasher)
      end

      def ==(other)
        return false unless other.is_a?(Appl)
        func == other.func && arg == other.arg
      end
    end
  end
end
