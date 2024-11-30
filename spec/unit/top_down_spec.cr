require "../../src/horn/top_down"

require "../spec_helper"

module Horn
  include Expressions

  p = {
    Pred.new("p_true")       => Expressions::True.new,
    Pred.new("p_false")      => Expressions::False.new,
    Pred.new("p_f0")         => Pred.new("p_f0"),
    Pred.new("p_not_f0")     => Not.new(Pred.new("p_f0")),
    Pred.new("p_f2")         => Not.new(Not.new(Pred.new("p_f2"))),
    Pred.new("p_and")        => And.new(Pred.new("p_true"), Pred.new("p_false")),
    Pred.new("p_or")         => Or.new(Pred.new("p_true"), Pred.new("p_false")),
    Pred.new("p_a")          => Lambda.new(Var.new("X"), Types::I, Eq.new(Var.new("X"), Const.new("a"))),
    Pred.new("p_b")          => Lambda.new(Var.new("X"), Types::I, Eq.new(Var.new("X"), Const.new("b"))),
    Pred.new("p_a_and_b")    => Exists.new(Var.new("X"), Types::I, And.new(Appl.new(Pred.new("p_a"), Var.new("X")), Appl.new(Pred.new("p_b"), Var.new("X")))),
    Pred.new("p_a_or_b")     => Exists.new(Var.new("X"), Types::I, Or.new(Appl.new(Pred.new("p_a"), Var.new("X")), Appl.new(Pred.new("p_b"), Var.new("X")))),
    Pred.new("p_exists")     => Exists.new(Var.new("X"), Types::I, Appl.new(Pred.new("p_a"), Var.new("X"))),
    Pred.new("p_exists_not") => Exists.new(Var.new("X"), Types::I, Not.new(Appl.new(Pred.new("p_a"), Var.new("X")))),
    Pred.new("p_error")      => Not.new(Pred.new("p_error")),

  }
  objects = [
    TypedExpr.new(Pred.new("p_true"), Types::O),
    TypedExpr.new(Pred.new("p_false"), Types::O),
    TypedExpr.new(Pred.new("p_f0"), Types::O),
    TypedExpr.new(Pred.new("p_f2"), Types::O),
    TypedExpr.new(Pred.new("p_and"), Types::O),
    TypedExpr.new(Pred.new("p_a"), Types::Arrow.new(Types::I, Types::O)),
    TypedExpr.new(Pred.new("p_b"), Types::Arrow.new(Types::I, Types::O)),
    TypedExpr.new(Pred.new("p_a_and_b"), Types::O),
    TypedExpr.new(Pred.new("p_a_or_b"), Types::O),
    TypedExpr.new(Pred.new("p_exists"), Types::O),
    TypedExpr.new(Pred.new("p_error"), Types::O),
    TypedExpr.new(Const.new("a"), Types::I),
    TypedExpr.new(Const.new("b"), Types::I),
  ]
  strategy = TopDown.new(p, objects)
  describe TopDown do
    it "evals" do
      strategy.eval(Pred.new("p_true")).true?.should be_true
      strategy.eval(Pred.new("p_false")).false?.should be_true
      strategy.eval(Pred.new("p_f0")).false?.should be_true
      strategy.eval(Pred.new("p_not_f0")).true?
      strategy.eval(Pred.new("p_f2")).false?.should be_true
      strategy.eval(Pred.new("p_and")).false?.should be_true
      strategy.eval(Pred.new("p_or")).true?.should be_true
      strategy.eval(Appl.new(Pred.new("p_a"), Const.new("a"))).true?.should be_true
      strategy.eval(Appl.new(Pred.new("p_a"), Const.new("b"))).false?.should be_true
      strategy.eval(Pred.new("p_b")).as(Values::Set)[Const.new("b")].true?.should be_true
      strategy.eval(Pred.new("p_b")).as(Values::Set)[Const.new("a")].false?.should be_true
      strategy.eval(Pred.new("p_a_and_b")).false?.should be_true
      strategy.eval(Pred.new("p_a_or_b")).true?.should be_true
      strategy.eval(Pred.new("p_exists")).true?.should be_true
      strategy.eval(Pred.new("p_exists_not")).true?.should be_true
      strategy.eval(Pred.new("p_error")).undef?.should be_true
    end
  end
end
