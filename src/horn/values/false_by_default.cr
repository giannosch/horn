require "../expressions/expr"

module Horn
  module Values
    class FalseByDefault < Value
      getter negation_depth = 0
      getter due_to : ::Set(Expr)

      def initialize(expr : Expr, negation_depth = 0)
        initialize([expr].to_set, negation_depth)
      end

      def initialize(@due_to : ::Set(Expr), @negation_depth = 0)
      end

      def false?
        negation_depth % 2 == 0
      end

      def undef?
        !false?
      end

      def |(other)
        return other | self unless other.is_a?(FalseByDefault)
        case {false?, other.false?}
        when {true, false}
          other
        when {false, true}
          self
        else
          FalseByDefault.new(due_to | other.due_to, [negation_depth, other.negation_depth].min)
        end
      end

      def &(other)
        return other & self unless other.is_a?(FalseByDefault)
        case {false?, other.false?}
        when {true, false}
          self
        when {false, true}
          other
        else
          FalseByDefault.new(due_to | other.due_to, [negation_depth, other.negation_depth].min)
        end
      end

      def ~
        if due_to.empty?
          return false? ? True.new : False.new
        end
        FalseByDefault.new(due_to, negation_depth + 1)
      end

      def empty?
        due_to.empty?
      end

      def to_s(io)
        if false?
          io << "F#{negation_depth}"
        else
          io << "ERROR"
        end
      end

      def inspect(io)
        to_s(io)
      end

      def hash(hasher)
        {self.class, negation_depth}.hash(hasher)
      end

      def ==(other)
        return false unless other.is_a?(FalseByDefault)
        negation_depth == other.negation_depth
      end
    end
  end
end
