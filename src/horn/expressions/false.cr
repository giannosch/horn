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

      def hash
        self.class.hash
      end

      def ==(other)
        other.is_a?(False)
      end
    end
  end
end
