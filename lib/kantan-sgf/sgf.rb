dir = File.dirname(__FILE__)
require 'rubygems'
require 'treetop'

# Grammar
require "#{dir}/../grammar/sgf-grammar"

module KantanSgf
  class Sgf
  
    attr_accessor :move_list, :properties
  
    def initialize(file)
      @file = file
      @data = nil
      @properties = {}
    
      @symbol_table = {}
      a = 'a'
      for i in 0..18
        @symbol_table.store(a, i)
        a = a.succ
      end
    
      @move_list = []
    end

    def parse
      f = File.open(@file)
      @data = f.read
      f.close
      
      @sgf = SgfGrammarParser.new
      results = @sgf.parse(@data)
      raise "Parsing failed due to [#{@sgf.failure_reason}]." if results.nil?
      
      # Pull the data out of the Treetop grammar parser
      data = results.value
      
      # Header info
      header = data.shift
      header.each do |chunk|
        @properties.store(chunk[:property], chunk[:data])
      end
      # Footer info
      footer = data.pop
      footer.each do |chunk|
        @properties.store(chunk[:property], chunk[:data])
      end
      # Moves
      data.each do |chunk|
        move = {}
        chunk.each do |info|
          case info[:property]
            when 'B', 'W'
              move[:color] = info[:property]
              if !info[:data].empty?
                move[:x] = @symbol_table[info[:data][0].chr]
                move[:y] = @symbol_table[info[:data][1].chr]
              end
            when 'BL', 'WL'
              move[:time] = info[:data]
            when 'OB', 'OW'
              move[:ot_stones] = info[:data]
          end
        end
        @move_list << move
      end
    end
  
    def player_black
      return @properties["PB"]
    end
  
    def player_white
      return @properties["PW"]
    end
  
    def rank_black
      return @properties["BR"]
    end
  
    def rank_white
      return @properties["WR"]
    end
  
    def board_size
      return @properties.include?("SZ") ? @properties["SZ"].to_i : 19
    end
  
    def komi
      return @properties["KM"]
    end
  
    def result
      return @properties["RE"]
    end
  
    def handicap
      return @properties["HA"]
    end
  
    def player_time
      return @properties["TM"]
    end
  
    def game_date
      return @properties["DT"]
    end
  
    def game_event
      return @properties["EV"]
    end
  
    def game_round
      return @properties["RO"]
    end
  
    def game_place
      return @properties["PC"]
    end
  
    def game_rules
      return @properties["RU"]
    end
  
    def game_name
      return @properties["GN"]
    end
  
  end
end