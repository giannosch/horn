require "./expressions/expr"
require "./expressions/const"

module Horn
  alias Program = Hash(Expressions::Const, Expr)
end
