require "./expressions/*"

module Horn
  module VarHelper
    include Expressions

    def assign_vars(expr : Expr, s : State) : Expr
      return expr if s.empty?

      case expr
      when Var
        if s.has_key?(expr)
          s[expr]
        else
          expr
        end
      when And
        And.new(assign_vars(expr.left, s), assign_vars(expr.right, s))
      when Or
        Or.new(assign_vars(expr.left, s), assign_vars(expr.right, s))
      when Appl
        Appl.new(assign_vars(expr.func, s), assign_vars(expr.arg, s))
      when Lambda
        Lambda.new(expr.param, expr.param_type, assign_vars(expr.body, s.reject(expr.param)))
      when Not
        Not.new(assign_vars(expr.expr, s))
      when Exists
        Exists.new(expr.var, expr.var_type, assign_vars(expr.expr, s.reject(expr.var)))
      when Forall
        Forall.new(expr.var, expr.var_type, assign_vars(expr.expr, s.reject(expr.var)))
      when Eq
        Eq.new(assign_vars(expr.left, s), assign_vars(expr.right, s))
      else
        expr
      end
    end

    def free_vars?(expr : Expr, except = Set(Var).new) : Bool
      case expr
      when Var
        !except.includes?(expr)
      when And, Or, Eq, Not, Appl
        expr.children.any? { |child| free_vars?(child, except) }
      when Lambda, Exists, Forall
        except = except.dup << expr.bounded_var
        expr.children.any? { |child| free_vars?(child, except) }
      else
        false
      end
    end
  end
end
