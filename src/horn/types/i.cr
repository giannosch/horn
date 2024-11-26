require "./type"

module Horn
  module Types
    class I
      def self.to_s(io)
        io << "ι"
      end

      def self.inspect(io)
        io << "ι"
      end
    end
  end
end
