require "./expr"

module Horn
  module Expressions
    class Prop < Expr
      property name : String

      def initialize(@name : String)
      end

      def to_s(io)
        io << name.downcase
      end

      def inspect(io)
        io << name.downcase
      end

      def hash
        name.hash
      end

      def ==(other)
        return false unless other.is_a?(Prop)
        name == other.name
      end
    end
  end
end
