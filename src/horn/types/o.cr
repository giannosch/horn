require "./type"

module Horn
  module Types
    class O
      def self.to_s(io)
        io << "ο"
      end

      def self.inspect(io)
        io << "ο"
      end
    end
  end
end
