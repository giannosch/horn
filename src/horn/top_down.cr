require "./caching"
require "./const_collection"
require "./expressions/*"
require "./program"
require "./state"
require "./types/*"
require "./values/*"
require "./visualizer"

module Horn
  class TopDown
    include Expressions

    @visualizer = Visualizer.new

    def initialize(@p : Program, @const_collection : ConstCollection)
      @cache = Caching.new(@const_collection)
    end

    def eval(q : Expr, parent_id : String? = nil) : Value
      q = q.as(Expr)
      visualizer_node = @visualizer.new_node(q, parent_id)

      visualizer_node.value = Values::FalseByDefault.new(q)
      if cached = @cache[q]
        visualizer_node.value = cached
        return cached
      end
      @cache[q] = Values::FalseByDefault.new(q)

      value =
        case q
        when True
          Values::True.new
        when False
          Values::False.new
        when Const, Appl
          r = reduct(q)
          raise "Cannot reduce #{q}" unless r[1]
          eval(r[0], visualizer_node.id)
        when Lambda
          @const_collection.select do |const, type|
            type == q.param_type
          end.keys.each_with_object(Values::Set.new) do |const, set|
            set[const] = eval(Appl.new(q, const), visualizer_node.id)
          end
        when And
          if (val = eval(q.left, visualizer_node.id)).is_a?(Values::False)
            val
          else
            val & eval(q.right, visualizer_node.id)
          end
        when Or
          if (val = eval(q.left, visualizer_node.id)).is_a?(Values::True)
            val
          else
            val | eval(q.right, visualizer_node.id)
          end
        when Not
          ~eval(q.expr, visualizer_node.id)
        when Eq
          if !@const_collection.has_key?(q.left) || @const_collection[q.left] != @const_collection[q.right]
            raise "Cannot compare #{q.left} to #{q.right}"
          end
          (q.left == q.right) ? Values::True.new : Values::False.new
        when Exists
          @const_collection.select do |const, type|
            type == q.var_type
          end.keys.map do |const|
            if (val = eval(Appl.new(Lambda.new(q.var, q.var_type, q.expr), const), visualizer_node.id)).true?
              break [val]
            end
            val.as(Value)
          end.reduce do |acc, val|
            acc | val
          end
        else
          raise "Unknown expression: #{q}"
        end

      value.due_to.delete(q) if value.is_a?(Values::FalseByDefault)
      visualizer_node.value = value
      @cache[q] = value

      value
    end

    def reduct(q : Expr) : {Expr, Bool}
      case q
      when True, False, Var, Eq, Not
        {q, false}
      when Lambda
        r = reduct(q.body)
        {Lambda.new(q.param, q.param_type, r[0]), r[1]}
      when And
        r = reduct(q.left)
        if r[1]
          {And.new(r[0], q.right), true}
        else
          r = reduct(q.right)
          {And.new(q.left, r[0]), r[1]}
        end
      when Or
        r = reduct(q.left)
        if r[1]
          {Or.new(r[0], q.right), true}
        else
          r = reduct(q.right)
          {Or.new(q.left, r[0]), r[1]}
        end
      when Exists
        r = reduct(q.expr)
        {Exists.new(q.var, q.var_type, r[0]), r[1]}
      when Appl
        func, arg = q.func, q.arg
        case func
        when False
          {False.new, true}
        when Lambda
          {assign_vars(func.body, {func.param => arg}), true}
        when And
          {And.new(Appl.new(func.left, arg), Appl.new(func.right, arg)), true}
        when Or
          {Or.new(Appl.new(func.left, arg), Appl.new(func.right, arg)), true}
        else
          r = reduct(func)
          if r[1]
            {Appl.new(r[0], arg), true}
          else
            r = reduct(arg)
            {Appl.new(func, r[0]), r[1]}
          end
        end
      when Const
        if !@const_collection[q].predicate?
          {q, false}
        elsif @p.has_key?(q)
          {@p[q], true}
        else
          {False.new, true}
        end
      else
        raise "Unknown expression: #{q}"
      end
    end

    def assign_vars(q : Expr, s : State) : Expr
      return q if s.empty?

      case q
      when Var
        if s.has_key?(q)
          s[q]
        else
          q
        end
      when And
        And.new(assign_vars(q.left, s), assign_vars(q.right, s))
      when Or
        Or.new(assign_vars(q.left, s), assign_vars(q.right, s))
      when Appl
        Appl.new(assign_vars(q.func, s), assign_vars(q.arg, s))
      when Lambda
        Lambda.new(q.param, q.param_type, assign_vars(q.body, s.reject(q.param)))
      when Not
        Not.new(assign_vars(q.expr, s))
      when Exists
        Exists.new(q.var, q.var_type, assign_vars(q.expr, s))
      when Eq
        Eq.new(assign_vars(q.left, s), assign_vars(q.right, s))
      else
        q
      end
    end

    def visualize
      @visualizer.to_json
    end
  end
end
