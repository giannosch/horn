require "./parser"
require "./ts_parser"
require "../types/*"

module Horn
  class TypeParser
    include Types

    def initialize(@ts_parser : TSParser)
    end

    def parse(node : TSParser::Node) : Type
      case node.type
      when "type_i"
        I.new
      when "type_o"
        O.new
      when "type_arrow"
        Arrow.new(parse(node.children[0]), parse(node.children[1]))
      else
        @ts_parser.raise_error(node, "Expected a type")
      end
    end
  end
end
