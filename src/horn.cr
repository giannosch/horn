require "./horn/expressions/*"
require "./horn/types/*"
require "./horn/typed_expression"
require "./horn/top_down"

module Horn
  include Expressions

  # e = [{"1", "2"}, {"2", "3"}, {"1", "4"}]
  # e = [{"1", "2"}, {"2", "3"}, {"3", "1"}]
  e = [{"1", "2"}, {"1", "3"}, {"2", "4"}, {"3", "9"}, {"4", "5"}, {"4", "7"}, {"5", "3"}, {"5", "7"}, {"6", "7"}, {"6", "2"}, {"7", "8"}, {"7", "9"}, {"8", "6"}]
  # e = [{"Z", "W1"}, {"U1", "A"}, {"Q1", "J"}, {"U1", "B1"}, {"B", "T1"}, {"X1", "X"}, {"N1", "Y"}, {"Q1", "F"}, {"B", "K"}, {"G1", "A"}, {"Q1", "I1"}, {"A1", "C1"}, {"S1", "V1"}, {"J", "E1"}, {"W", "D"}, {"F1", "A"}, {"M", "J1"}, {"G1", "N"}, {"J1", "H1"}, {"X1", "T"}, {"E", "Y"}, {"F1", "D"}, {"F", "U"}, {"S1", "N"}, {"T1", "B1"}, {"J1", "D1"}, {"Z", "V1"}, {"Q1", "U"}, {"K", "P"}, {"W", "I1"}, {"B", "A1"}, {"P1", "I"}, {"P1", "X1"}, {"D", "Q"}, {"W1", "L1"}, {"R", "B"}, {"U1", "M1"}, {"P", "M1"}, {"A", "Q"}, {"X1", "Q1"}, {"O", "I"}, {"M", "Y"}, {"D", "G1"}, {"B1", "O1"}, {"R1", "F1"}, {"B", "A"}, {"E", "P"}, {"A1", "V"}, {"G1", "U"}, {"L1", "C1"}, {"S1", "D"}, {"C", "M"}, {"M1", "W"}, {"R1", "N"}, {"X1", "Q"}, {"F", "R"}, {"D1", "Y"}, {"Z", "Y"}, {"I", "P1"}, {"X1", "W"}, {"C", "C1"}, {"F", "P1"}, {"V1", "H1"}, {"I1", "P"}, {"K", "E"}, {"C", "E"}, {"C1", "A"}, {"N1", "F1"}, {"I", "W1"}, {"P", "N1"}, {"R1", "W"}, {"X1", "C1"}, {"F", "S1"}, {"O1", "C"}, {"G1", "T1"}, {"C1", "T"}, {"C1", "H"}, {"C1", "E1"}, {"E", "J"}, {"V1", "R"}, {"A", "W"}, {"W1", "I"}, {"K", "U"}, {"C", "R1"}, {"I1", "V1"}, {"K", "T1"}, {"J", "K"}, {"O1", "I1"}, {"Y", "P"}, {"G1", "U1"}, {"S1", "B1"}, {"M", "W1"}, {"R1", "B"}, {"P1", "N1"}, {"E1", "O"}, {"I", "Z"}, {"V1", "U"}, {"M", "N"}, {"M1", "M"}, {"C1", "J"}]
  v = e.map(&.to_a).flatten.uniq
  # v << "alone"

  p = {Prop.new("v") => Lambda.new(Var.new("X"), Types::I,
    Or.from_list(v.map { |x| Eq.new(Var.new("X"), Const.new(x.to_s)) })
  ).as(Expr)}

  p.merge!({Prop.new("e") => Lambda.new(Var.new("X"), Types::I,
    Lambda.new(Var.new("Y"), Types::I,
      Or.from_list(e.map { |x, y| And.new(Eq.new(Var.new("X"), Const.new(x.to_s)), Eq.new(Var.new("Y"), Const.new(y.to_s))) })
    )).as(Expr)})

  p.merge!({
    Prop.new("remove") => Lambda.new(Var.new("V"), Types::Arrow.new(Types::I, Types::O),
      Lambda.new(Var.new("A"), Types::I,
        Lambda.new(Var.new("X"), Types::I,
          And.new(
            Appl.new(Var.new("V"), Var.new("X")),
            Not.new(Eq.new(Var.new("X"), Var.new("A")))
          )
        ))).as(Expr),
    Prop.new("remove2") => Lambda.new(Var.new("E"), Types::Arrow.new(Types::I, Types::Arrow.new(Types::I, Types::O)),
      Lambda.new(Var.new("A"), Types::I,
        Lambda.new(Var.new("X"), Types::I,
          Lambda.new(Var.new("Y"), Types::I,
            And.new(
              Appl.new(Appl.new(Var.new("E"), Var.new("X")), Var.new("Y")),
              And.new(
                Not.new(Eq.new(Var.new("X"), Var.new("A"))),
                Not.new(Eq.new(Var.new("Y"), Var.new("A")))
              )
            )
          )))).as(Expr),
    Prop.new("winning") => Lambda.new(Var.new("V"), Types::Arrow.new(Types::I, Types::O),
      Lambda.new(Var.new("E"), Types::Arrow.new(Types::I, Types::Arrow.new(Types::I, Types::O)),
        Lambda.new(Var.new("X"), Types::I,
          Exists.new(Var.new("Y"), Types::I,
            And.from_list([
              Appl.from_list([Var.new("E"), Var.new("X"), Var.new("Y")]),
              Not.new(Eq.new(Var.new("X"), Var.new("Y"))),
              Not.new(Appl.from_list([
                Prop.new("winning"),
                Appl.from_list([Prop.new("remove"), Var.new("V"), Var.new("X")]),
                Appl.from_list([Prop.new("remove2"), Var.new("E"), Var.new("X")]),
                Var.new("Y"),
              ])),
            ])
          )))).as(Expr),
    Prop.new("transitive") => Lambda.new(Var.new("R"), Types::Arrow.new(Types::I, Types::Arrow.new(Types::I, Types::O)),
      Lambda.new(Var.new("X"), Types::I,
        Lambda.new(Var.new("Y"), Types::I,
          Or.new(
            Appl.new(Appl.new(Var.new("R"), Var.new("X")), Var.new("Y")),
            Exists.new(Var.new("Z"), Types::I,
              And.new(
                Appl.new(Appl.new(Var.new("R"), Var.new("X")), Var.new("Z")),
                Appl.from_list([
                  Prop.new("transitive"),
                  Var.new("R"),
                  Var.new("Z"),
                  Var.new("Y"),
                ])
              )
            )
          )
        ))).as(Expr),
    Prop.new("disconnected") => Lambda.new(Var.new("V"), Types::Arrow.new(Types::I, Types::O),
      Lambda.new(Var.new("E"), Types::Arrow.new(Types::I, Types::Arrow.new(Types::I, Types::O)),
        Lambda.new(Var.new("X"), Types::I,
          Exists.new(Var.new("Y"), Types::I,
            And.new(
              Not.new(Eq.new(Var.new("X"), Var.new("Y"))),
              Not.new(Appl.from_list([
                Prop.new("transitive"), Var.new("E"), Var.new("X"), Var.new("Y"),
              ]))
            )
          )))).as(Expr),
  })

  objects = v.map { |x| TypedExpr.new(Const.new(x.to_s), Types::I) }
  objects << TypedExpr.new(Prop.new("e"), Types::Arrow.new(Types::I, Types::Arrow.new(Types::I, Types::O)))
  objects << TypedExpr.new(Prop.new("v"), Types::Arrow.new(Types::I, Types::O))
  objects << TypedExpr.new(Prop.new("transitive"), Types::Arrow.new(Types::Arrow.new(Types::O, Types::O), Types::Arrow.new(Types::I, Types::O)))

  strategy = TopDown.new(p, objects)

  puts strategy.eval(Appl.from_list([
    Prop.new("winning"),
    Prop.new("v"),
    Prop.new("e"),
    Const.new(v.first.to_s),
  ]))

  # puts strategy.eval(Appl.from_list([
  #   Prop.new("disconnected"),
  #   Prop.new("v"),
  #   Prop.new("e"),
  #   Const.new(v.first.to_s),
  # ]))

  # puts strategy.visualize
end
