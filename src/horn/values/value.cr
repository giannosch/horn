module Horn
  abstract class Value
    def self.from_bool(b : Bool)
      (b ? Values::True : Values::False).new
    end
  end
end
