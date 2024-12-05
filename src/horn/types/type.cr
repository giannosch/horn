module Horn
  class Type
    def predicate?
      false
    end

    def to_json(builder : JSON::Builder)
      self.to_s.to_json(builder)
    end
  end
end
