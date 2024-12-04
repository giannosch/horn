@[Link(ldflags: "-L#{__DIR__}/../../../tree-sitter-horn/ -l:libtree-sitter-horn.a")]
@[Link(ldflags: "-L/usr/ -ltree-sitter")]
lib TSLib
  struct TSLanguage
    _unused : UInt32
  end

  struct TSParser
    _unused : UInt32
  end

  struct TSTree
    _unused : UInt32
  end

  struct TSNode
    context : UInt32[4]
    id : Pointer(Void)
    tree : Pointer(TSTree)
  end

  struct TSPoint
    row : UInt32
    column : UInt32
  end

  fun tree_sitter_horn : Pointer(TSLanguage)
  fun ts_node_end_byte(node : TSNode) : UInt32
  fun ts_node_end_point(node : TSNode) : TSPoint
  fun ts_node_named_child_count(node : TSNode) : UInt32
  fun ts_node_named_child(node : TSNode, child_index : UInt32) : TSNode
  fun ts_node_start_byte(node : TSNode) : UInt32
  fun ts_node_start_point(node : TSNode) : TSPoint
  fun ts_node_string(node : TSNode) : UInt8*
  fun ts_node_type(node : TSNode) : UInt8*
  fun ts_parser_delete(parser : Pointer(TSParser))
  fun ts_parser_new : Pointer(TSParser)
  fun ts_parser_parse_string(parser : Pointer(TSParser), null : Pointer(Void), source : UInt8*, length : Int32) : Pointer(TSTree)
  fun ts_parser_set_language(parser : Pointer(TSParser), language : Pointer(TSLanguage))
  fun ts_tree_delete(tree : Pointer(TSTree))
  fun ts_tree_root_node(tree : Pointer(TSTree)) : TSNode
end
