require "./value"
require "./true"

module Horn
  module Values
    class False < Value
      def to_bool
        false
      end

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
