require "./expr"

module Horn
  module Expressions
    class Const < Expr
      getter name : String

      def initialize(@name : String)
      end

      def to_s(io)
        io << name.downcase
      end

      def inspect(io)
        io << name.downcase
      end

      def to_json_object_key
        to_s.to_json_object_key
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
