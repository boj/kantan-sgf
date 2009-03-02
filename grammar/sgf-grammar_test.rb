dir = File.dirname(__FILE__)
require 'rubygems'
require 'treetop'
require "test/unit"

# Grammar
Treetop.load "#{dir}/sgf-grammar.tt"

class SgfGrammarTest < Test::Unit::TestCase
  
  def setup
    @sgf = SgfGrammarParser.new
    f = File.open("../data/stoic-bojo.sgf")
    @data = f.read
    f.close
  end
  
  def test_parse
    result = @sgf.parse(@data)
    assert result
  end
  
end