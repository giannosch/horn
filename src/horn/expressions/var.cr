require "./expr"

module Horn
  module Expressions
    class Var < Expr
      property name : String

      def initialize(@name : String)
      end

      def to_s(io)
        io << name.titleize
      end

      def inspect(io)
        io << name.titleize
      end

      def hash(hasher)
        {self.class, name}.hash(hasher)
      end

      def ==(other)
        return false unless other.is_a?(Var)
        name == other.name
      end
    end
  end
end
