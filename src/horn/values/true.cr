require "./value"
require "./false"

module Horn
  module Values
    class True < Value
      def true?
        true
      end

      def |(other)
        self
      end

      def &(other)
        other
      end

      def ~
        False.new
      end

      def to_s(io)
        io << "T"
      end

      def inspect(io)
        io << "T"
      end

      def hash(hasher)
        self.class.hash(hasher)
      end

      def ==(other)
        other.is_a?(True)
      end
    end
  end
end
