require "./value"
require "./true"

module Horn
  module Values
    class False < Value
      def false?
        true
      end

      def |(other)
        other
      end

      def &(other)
        self
      end

      def ~
        True.new
      end

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
