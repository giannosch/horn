require "./expressions/*"

module Horn
  class Caching
    include Expressions

    @cache = Hash(Expr, Value).new
    @valid_exprs : ::Set(Expr)

    def initialize(objects)
      @valid_exprs = objects.map(&.expr).to_set
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
      when Prop, Const
        @valid_exprs.includes?(expr)
      else
        false
      end
    end
  end
end
