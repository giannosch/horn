require "./type"

module Horn
  module Types
    class O < Type
      def to_s(io)
        io << "ο"
      end

      def inspect(io)
        io << "ο"
      end

      def ==(other)
        other.is_a?(O)
      end
    end
  end
end
