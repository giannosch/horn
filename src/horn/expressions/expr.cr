module Horn
  abstract class Expr
    def to_json(builder : JSON::Builder)
      "#{self.class.to_s.split("::").last}: #{self.to_s}".to_json(builder)
    end

    def children
      [] of Expr
    end
  end
end
