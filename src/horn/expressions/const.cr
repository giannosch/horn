require "./expr"

module Horn
  module Expressions
    class Const < Expr
      property name : String

      def initialize(@name : String)
      end

      def to_s(io)
        io << name.downcase
      end

      def inspect(io)
        io << name.downcase
      end

      def hash(hasher)
        {self.class, name}.hash(hasher)
      end

      def ==(other)
        return false unless other.is_a?(Const)
        name == other.name
      end
    end
  end
end
