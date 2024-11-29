require "../../src/horn/top_down"

require "../spec_helper"

module Horn
  include Expressions

  p = {
    Prop.new("p_true")       => Expressions::True.new,
    Prop.new("p_false")      => Expressions::False.new,
    Prop.new("p_f0")         => Prop.new("p_f0"),
    Prop.new("p_not_f0")     => Not.new(Prop.new("p_f0")),
    Prop.new("p_f2")         => Not.new(Not.new(Prop.new("p_f2"))),
    Prop.new("p_and")        => And.new(Prop.new("p_true"), Prop.new("p_false")),
    Prop.new("p_or")         => Or.new(Prop.new("p_true"), Prop.new("p_false")),
    Prop.new("p_a")          => Lambda.new(Var.new("X"), Types::I, Eq.new(Var.new("X"), Const.new("a"))),
    Prop.new("p_b")          => Lambda.new(Var.new("X"), Types::I, Eq.new(Var.new("X"), Const.new("b"))),
    Prop.new("p_a_and_b")    => Exists.new(Var.new("X"), Types::I, And.new(Appl.new(Prop.new("p_a"), Var.new("X")), Appl.new(Prop.new("p_b"), Var.new("X")))),
    Prop.new("p_a_or_b")     => Exists.new(Var.new("X"), Types::I, Or.new(Appl.new(Prop.new("p_a"), Var.new("X")), Appl.new(Prop.new("p_b"), Var.new("X")))),
    Prop.new("p_exists")     => Exists.new(Var.new("X"), Types::I, Appl.new(Prop.new("p_a"), Var.new("X"))),
    Prop.new("p_exists_not") => Exists.new(Var.new("X"), Types::I, Not.new(Appl.new(Prop.new("p_a"), Var.new("X")))),
    Prop.new("p_error")      => Not.new(Prop.new("p_error")),

  }
  objects = [
    TypedExpr.new(Prop.new("p_true"), Types::O),
    TypedExpr.new(Prop.new("p_false"), Types::O),
    TypedExpr.new(Prop.new("p_f0"), Types::O),
    TypedExpr.new(Prop.new("p_f2"), Types::O),
    TypedExpr.new(Prop.new("p_and"), Types::O),
    TypedExpr.new(Prop.new("p_a"), Types::Arrow.new(Types::I, Types::O)),
    TypedExpr.new(Prop.new("p_b"), Types::Arrow.new(Types::I, Types::O)),
    TypedExpr.new(Prop.new("p_a_and_b"), Types::O),
    TypedExpr.new(Prop.new("p_a_or_b"), Types::O),
    TypedExpr.new(Prop.new("p_exists"), Types::O),
    TypedExpr.new(Prop.new("p_error"), Types::O),
    TypedExpr.new(Const.new("a"), Types::I),
    TypedExpr.new(Const.new("b"), Types::I),
  ]
  strategy = TopDown.new(p, objects)
  describe TopDown do
    it "evals" do
      strategy.eval(Prop.new("p_true")).true?.should be_true
      strategy.eval(Prop.new("p_false")).false?.should be_true
      strategy.eval(Prop.new("p_f0")).false?.should be_true
      strategy.eval(Prop.new("p_not_f0")).true?
      strategy.eval(Prop.new("p_f2")).false?.should be_true
      strategy.eval(Prop.new("p_and")).false?.should be_true
      strategy.eval(Prop.new("p_or")).true?.should be_true
      strategy.eval(Appl.new(Prop.new("p_a"), Const.new("a"))).true?.should be_true
      strategy.eval(Appl.new(Prop.new("p_a"), Const.new("b"))).false?.should be_true
      strategy.eval(Prop.new("p_b")).as(Values::Set)[Const.new("b")].true?.should be_true
      strategy.eval(Prop.new("p_b")).as(Values::Set)[Const.new("a")].false?.should be_true
      strategy.eval(Prop.new("p_a_and_b")).false?.should be_true
      strategy.eval(Prop.new("p_a_or_b")).true?.should be_true
      strategy.eval(Prop.new("p_exists")).true?.should be_true
      strategy.eval(Prop.new("p_exists_not")).true?.should be_true
      strategy.eval(Prop.new("p_error")).undef?.should be_true
    end
  end
end
