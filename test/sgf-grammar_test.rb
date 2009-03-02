dir = File.dirname(__FILE__)
require 'rubygems'
require 'treetop'
require "test/unit"

# Grammar
Treetop.load "#{dir}/../lib/grammar/sgf-grammar.tt"

class SgfGrammarTest < Test::Unit::TestCase
  
  def setup
    @sgf = SgfGrammarParser.new
    f = File.open("../data/game-01.sgf")
    @data = f.read
    f.close
  end
  
  def test_parse
    result = @sgf.parse(@data)
    #puts @sgf.failure_reason
    #puts result.value.inspect
    assert result
  end
  
end