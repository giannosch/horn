require "./parser"
require "./ts_parser"
require "../expressions/*"

module Horn
  class ExpressionParser
    include Expressions

    def initialize(@ts_parser : TSParser, @type_parser : TypeParser, @const_collection : ConstCollection)
    end

    def parse(node) : Expr
      case node.type
      when "body"
        And.from_list(node.children.map { |child| parse(child) })
      when "existential_body"
        parse_exists(node)
      when "false"
        False.new
      when "true"
        True.new
      when "const"
        parse_const(node)
      when "var"
        parse_var(node)
      when "lambda"
        parse_lambda(node)
      when "application"
        Appl.from_list(node.children.map { |child| parse(child) })
      when "or"
        Or.from_list(node.children.map { |child| parse(child) })
      when "and"
        And.from_list(node.children.map { |child| parse(child) })
      when "not"
        Not.new(parse(node.children[0]))
      when "eq"
        Eq.new(parse(node.children[0]), parse(node.children[1]))
      when "exists"
        parse_exists(node)
      else
        @ts_parser.raise_error(node, "Unknown expression.")
      end
    end

    def parse_const(node, skip_validation = false) : Expressions::Const
      @ts_parser.raise_error(node, "Expected a constant.") if node.type != "const"
      Const.new(node.content.not_nil!).tap do |const|
        @ts_parser.raise_error(node, "Unknown constant #{const}.") unless skip_validation || @const_collection.has_key?(const)
      end
    end

    def parse_predicate(node) : Expressions::Const
      parse_const(node).tap do |const|
        @ts_parser.raise_error(node, "Expected a predicate.") unless @const_collection[const].predicate?
      end
    end

    def parse_var(node) : Expressions::Var
      @ts_parser.raise_error(node, "Expected a variable.") if node.type != "var"
      Var.new(node.content.not_nil!)
    end

    def parse_lambda(node) : Expressions::Lambda
      var, type = if node.children[0].type == "typed_var"
                    parse_typed_var(node.children[0])
                  else
                    {parse_var(node.children[0]), nil}
                  end
      body = parse(node.children[1])
      Lambda.new(var, type, body)
    end

    def parse_exists(node) : Expressions::Exists
      var, type = parse_typed_var(node.children[0])
      expr = parse(node.children[1])
      Exists.new(var, type, expr)
    end

    def parse_typed_var(node) : {Expressions::Var, Type}
      @ts_parser.raise_error(node, "Expected a typed variable.") if node.type != "typed_var"
      {parse_var(node.children[0]), @type_parser.parse(node.children[1])}
    end
  end
end
