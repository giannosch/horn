require "./value"
require "./false"

module Horn
  module Values
    class True < Value
      def to_bool
        true
      end

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
