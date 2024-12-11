require "./expressions/*"
require "./values/value"
require "./const_collection"

module Horn
  class Caching(K, V)
    include Expressions

    @cache = Hash(K, V).new

    def initialize(@valid : Proc(K, Bool) = ->(key : K) { true })
    end

    def [](key : K)
      @cache[key]?
    end

    def []=(key : K, val : V)
      @cache[key] = val if @valid.call(key)
      val
    end
  end
end
