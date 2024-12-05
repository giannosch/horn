require "./expressions/*"
require "./values/value"
require "./const_collection"

module Horn
  class Caching
    include Expressions

    @cache = Hash(Expr, Value).new

    def initialize(@const_collection : ConstCollection)
    end

    def [](expr : Expr)
      @cache[expr]?
    end

    def []=(expr : Expr, val : Value)
      @cache[expr] = val if cache_expr?(expr)
      # puts (@cache) if cache_expr?(expr)
      val
    end

    def cache_expr?(expr : Expr)
      case expr
      when Appl
        cache_expr?(expr.func) && cache_expr?(expr.arg)
      when Const
        @const_collection.has_key?(expr)
      else
        false
      end
    end
  end
end
