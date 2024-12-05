require "../../src/horn/parser/parser"

require "../spec_helper"

module Horn
  describe Parser do
    it "parses" do
      parser = Parser.new("#{__DIR__}/../fixtures/program.horn")
      parser.parse
      parser.program.size.should eq(2)
      parser.const_collection.size.should eq(4)
      parser.queries.size.should eq(1)
    end
  end
end
