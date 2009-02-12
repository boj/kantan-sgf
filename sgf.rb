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
    @data = StringReader.new(f.read)
    f.close
    
    buffer    = ''
    property  = ''
    atoz      = ('A'..'Z').to_a
    while !@data.eod?
      c = @data.get
      if atoz.include?(c.chr)
        buffer += c.chr
      end
      if @data.next == ?[ and buffer.length > 0
        property = buffer
        buffer = ''
        @data.get # pop off the [
        n = true
        # Grab the property's data
        while v = @data.get and n == true
          if v != ?]
            buffer += v.chr
          else
            n = false
          end
        end
        # If it's a game move push it
        if ['B', 'W'].include?(property)
          @move_list.push(
            {
              :color => property, 
              :x => @symbol_table[buffer[0].chr].to_i, 
              :y => @symbol_table[buffer[1].chr].to_i
            }
          )
        else # Push it as a property
          @properties.store(property, buffer)
        end
        buffer    = ''
        property  = ''
      end
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

class StringReader
  
  def initialize(data)
    @data = data
    @index = 0
  end
  
  def get
    d = @data[@index]
    @index += 1
    return d
  end
  
  def next
    return @data[@index]
  end
  
  def eod?
    return true if @index >= @data.length
  end
  
end