require "../../src/horn/var_helper"

require "../spec_helper"

module Horn
  class VarHelperTest
    include VarHelper
  end

  var_helper = VarHelperTest.new

  describe VarHelper do
    it "assign_vars" do
      expr = Expressions::Appl.new(Expressions::Const.new("f"), Expressions::Var.new("X"))
      state = {Expressions::Var.new("X") => Expressions::Const.new("a")}
      var_helper.assign_vars(expr, state).should eq(Expressions::Appl.new(Expressions::Const.new("f"), Expressions::Const.new("a")))
    end

    it "checks free_vars?" do
      expr_var = Expressions::Var.new("X")
      var_helper.free_vars?(expr_var).should be_true

      expr_const = Expressions::Const.new("f")
      var_helper.free_vars?(expr_const).should be_false

      expr_lambda = Expressions::Lambda.new(Expressions::Var.new("X"), nil, Expressions::Var.new("X"))
      var_helper.free_vars?(expr_lambda).should be_false

      expr_and_lambda = Expressions::And.new(expr_lambda, expr_var)
      var_helper.free_vars?(expr_and_lambda).should be_true

      expr_appl = Expressions::Appl.new(expr_const, expr_var)
      var_helper.free_vars?(expr_appl).should be_true
    end
  end
end
