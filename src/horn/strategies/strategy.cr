module Horn
  abstract class Strategy
    def self.with_name(name : String)
      {{Strategy.subclasses}}.find { |s| s.name == name }
    end

    abstract def eval(expr : Expr)
    abstract def visualize
  end
end
