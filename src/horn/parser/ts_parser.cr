require "./bindings"

require "./node"

module Horn
  class TSParser
    def initialize(@source : String, @filename : String)
    end

    def parse
      parser = TSLib.ts_parser_new
      TSLib.ts_parser_set_language(parser, TSLib.tree_sitter_horn)
      tree = TSLib.ts_parser_parse_string(parser, nil, @source.to_unsafe, @source.size)
      root_node = TSLib.ts_tree_root_node(tree)

      parse_rec(root_node)
    end

    private def parse_rec(ts_node : TSLib::TSNode)
      Node.new(ts_node).tap do |node|
        raise_error(node) if node.error?
        if %w[var const].includes?(node.type)
          node.content = @source[TSLib.ts_node_start_byte(ts_node)...TSLib.ts_node_end_byte(ts_node)]
        end
        (0...TSLib.ts_node_named_child_count(ts_node)).each do |i|
          node.children << parse_rec(TSLib.ts_node_named_child(ts_node, i))
        end
      end
    end

    def raise_error(node : Node, error_description : String? = nil)
      error_description ||= node.to_s
      puts "Error at #{@filename}:#{node.row + 1}:#{node.column + 1}: #{error_description}\n"
      puts @source.split("\n")[node.row]
      puts (" " * node.column) + ("^" * (node.end_column - node.column))
      raise "Parsing error"
    end
  end
end
