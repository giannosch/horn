require "./expr"

module Horn
  module Expressions
    class True < Expr
      def to_s(io)
        io << "T"
      end

      def inspect(io)
        io << "T"
      end

      def hash
        self.class.hash
      end

      def ==(other)
        other.is_a?(True)
      end
    end
  end
end
