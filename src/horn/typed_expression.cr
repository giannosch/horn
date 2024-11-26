require "./expressions/expr"
require "./types/type"

module Horn
  record TypedExpr, expr : Expr, type : Type
end
