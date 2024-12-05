require "json"

require "./bindings"

module Horn
  class TSParser
    class Node
      include JSON::Serializable

      @[JSON::Field(ignore: true)]
      @ts_node : TSLib::TSNode

      property type : String
      property content : String?
      property children = Array(Node).new

      def initialize(@ts_node : TSLib::TSNode)
        @type = String.new(TSLib.ts_node_type(@ts_node))
      end

      def column
        start_point.column
      end

      def row
        start_point.row
      end

      def end_column
        end_point.column
      end

      def end_row
        end_point.row
      end

      def error?
        type == "ERROR"
      end

      def to_s
        String.new(TSLib.ts_node_string(@ts_node))
      end

      @[JSON::Field(ignore: true)]
      @start_point : TSLib::TSPoint?

      private def start_point
        @start_point ||= TSLib.ts_node_start_point(@ts_node)
      end

      @[JSON::Field(ignore: true)]
      @end_point : TSLib::TSPoint?

      private def end_point
        @end_point ||= TSLib.ts_node_end_point(@ts_node)
      end
    end
  end
end
