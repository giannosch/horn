require "uuid"
require "json"

require "./expressions/expr"
require "./values/value"

module Horn
  class Visualizer
    MAX_DEPTH = 49

    class Node
      include JSON::Serializable

      @[JSON::Field(ignore: true)]
      property id : String

      property children = Array(Node).new

      property expr : Expr

      property value : Value?

      @[JSON::Field(ignore: true)]
      property depth = 0

      def initialize(@id : String, @expr : Expr)
      end
    end

    @nodes = Hash(String, Node).new
    @roots = Array(Node).new

    def new_node(expr : Expr, parent_id : String? = nil)
      Node.new(UUID.random.to_s, expr).tap do |node|
        @nodes[node.id] = node
        if parent_id
          parent = @nodes[parent_id]
          node.depth = parent.depth + 1
          parent.children << node if node.depth < MAX_DEPTH
        end
        @roots << node if parent_id.nil?
      end
    end

    def to_json
      @roots.to_json
    end
  end
end
