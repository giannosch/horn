require "./expressions/*"
require "./program"
require "./state"
require "./types/*"
require "./values/*"
require "./visualizer"

module Horn
  class TopDown
    @visualizer = Visualizer.new

    def initialize(@p : Program, @objects : Array(TypedExpr))
    end

    def eval(q : Expr, parent_id : String? = nil) : Value
      visualizer_node = @visualizer.new_node(q, parent_id)

      case q
      when True
        Values::True.new
      when False
        Values::False.new
      when Prop, Appl
        r = reduct(q)
        raise "Cannot reduce #{q}" unless r[1]
        eval(r[0], visualizer_node.id)
      when Lambda
        @objects.select do |object|
          object.type == q.param_type
        end.each_with_object(Values::Set.new) do |object, set|
          set[object.expr] = eval(Appl.new(q, object.expr), visualizer_node.id)
        end
      when And
        case eval(q.left, visualizer_node.id)
        when Values::False
          Values::False.new
        when Values::True
          eval(q.right, visualizer_node.id)
        else
          raise "#{q.left} is not of type ο"
        end
      when Or
        case eval(q.left, visualizer_node.id)
        when Values::True
          Values::True.new
        when Values::False
          eval(q.right, visualizer_node.id)
        else
          raise "#{q.left} is not of type ο"
        end
      when Not
        val = eval(q.expr, visualizer_node.id).to_bool
        raise "#{q.expr} is not of type ο" if val.nil?
        Value.from_bool(!val)
      when Eq
        Value.from_bool(q.left == q.right)
      when Exists
        @objects.select do |object|
          object.type == q.var_type
        end.any? do |object|
          eval(Appl.new(Lambda.new(q.var, q.var_type, q.expr), object.expr), visualizer_node.id).to_bool
        end ? Values::True.new : Values::False.new
      else
        raise "Unknown expression: #{q}"
      end.tap do |value|
        visualizer_node.value = value
      end
    end

    def reduct(q : Expr) : {Expr, Bool}
      case q
      when True, False, Const, Var, Eq, Not
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
      when Prop
        if @p.has_key?(q)
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
