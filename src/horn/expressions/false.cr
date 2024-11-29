require "./expr"

module Horn
  module Expressions
    class False < Expr
      def to_s(io)
        io << "F"
      end

      def inspect(io)
        io << "F"
      end

      def hash(hasher)
        self.class.hash(hasher)
      end

      def ==(other)
        other.is_a?(False)
      end
    end
  end
end
