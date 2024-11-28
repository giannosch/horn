module Horn
  abstract class Value
    def self.from_bool(b : Bool)
      (b ? Values::True : Values::False).new
    end

    def to_json(builder : JSON::Builder)
      self.to_s.to_json(builder)
    end
  end
end
