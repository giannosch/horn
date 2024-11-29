require "../../src/horn/values/*"
require "../../src/horn/expressions/prop"

require "../spec_helper"

module Horn
  include Values

  dummy_expr = Expressions::Prop.new("dummy").as(Expr)

  describe Value do
    it "disjuncts" do
      (Values::True.new | Values::False.new).true?.should be_true
      (Values::True.new | FalseByDefault.new(dummy_expr, 0)).true?.should be_true
      (FalseByDefault.new(dummy_expr, 0) | Values::True.new).true?.should be_true
      (FalseByDefault.new(dummy_expr, 0) | Values::False.new).false?.should be_true
      (Values::False.new | FalseByDefault.new(dummy_expr, 0)).false?.should be_true
      (FalseByDefault.new(dummy_expr, 0) | FalseByDefault.new(dummy_expr, 1)).undef?.should be_true
      (FalseByDefault.new(dummy_expr, 0) | FalseByDefault.new(dummy_expr, 2)).false?.should be_true
      (FalseByDefault.new(dummy_expr, 1) | FalseByDefault.new(dummy_expr, 2)).undef?.should be_true
    end

    it "conjuncts" do
      (Values::True.new & Values::False.new).false?.should be_true
      (Values::True.new & FalseByDefault.new(dummy_expr, 0)).false?.should be_true
      (FalseByDefault.new(dummy_expr, 0) & Values::True.new).false?.should be_true
      (FalseByDefault.new(dummy_expr, 0) & Values::False.new).false?.should be_true
      (FalseByDefault.new(dummy_expr, 0) & FalseByDefault.new(dummy_expr, 1)).false?.should be_true
      (FalseByDefault.new(dummy_expr, 0) & FalseByDefault.new(dummy_expr, 2)).false?.should be_true
      (FalseByDefault.new(dummy_expr, 1) & FalseByDefault.new(dummy_expr, 2)).false?.should be_true
    end
  end
end
