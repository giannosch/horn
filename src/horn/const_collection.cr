require "./expressions/const"
require "./types/type"

module Horn
  alias ConstCollection = Hash(Expressions::Const, Type)
end
