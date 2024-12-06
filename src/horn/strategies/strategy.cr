module Horn
  abstract class Strategy
    abstract def eval(expr : Expr)
    abstract def visualize
  end
end
