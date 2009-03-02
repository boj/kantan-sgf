module SgfGrammar
  include Treetop::Runtime

  def root
    @root || :node
  end

  module Node0
    def sp
      elements[1]
    end

    def sp
      elements[3]
    end

    def sp
      elements[5]
    end
  end

  module Node1
			def value
				get([elements[2]])
			end
			
			def get(e)
				a = []
				if !e.nil?
			    e.each do |el|
						if el.respond_to?(:value)
							a << el.value
						else
			      	a += get(el.elements) if !el.nil?
			      end
			    end
			  end
				a
			end
  end

  def _nt_node
    start_index = index
    if node_cache[:node].has_key?(index)
      cached = node_cache[:node][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('(', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('(')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_sp
      s0 << r2
      if r2
        s3, i3 = [], index
        loop do
          r4 = _nt_chunk
          if r4
            s3 << r4
          else
            break
          end
        end
        r3 = SyntaxNode.new(input, i3...index, s3)
        s0 << r3
        if r3
          r5 = _nt_sp
          s0 << r5
          if r5
            if input.index(')', index) == index
              r6 = (SyntaxNode).new(input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(')')
              r6 = nil
            end
            s0 << r6
            if r6
              r7 = _nt_sp
              s0 << r7
            end
          end
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Node0)
      r0.extend(Node1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:node][start_index] = r0

    return r0
  end

  module Chunk0
    def sp
      elements[1]
    end

    def sp
      elements[3]
    end
  end

  module Chunk1
			def value
				get([elements[2]])
			end
			
			def get(e)
				a = []
				if !e.nil?
			    e.each do |el|
						if el.respond_to?(:value)
							a << el.value
						else
			      	a += get(el.elements) if !el.nil?
			      end
			    end
			  end
				a
			end
  end

  def _nt_chunk
    start_index = index
    if node_cache[:chunk].has_key?(index)
      cached = node_cache[:chunk][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index(';', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure(';')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_sp
      s0 << r2
      if r2
        s3, i3 = [], index
        loop do
          r4 = _nt_property_set
          if r4
            s3 << r4
          else
            break
          end
        end
        r3 = SyntaxNode.new(input, i3...index, s3)
        s0 << r3
        if r3
          r5 = _nt_sp
          s0 << r5
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Chunk0)
      r0.extend(Chunk1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:chunk][start_index] = r0

    return r0
  end

  module PropertySet0
    def property
      elements[0]
    end

    def sp
      elements[2]
    end
  end

  module PropertySet1
			def value
				{ 
					:property => elements[0].text_value, 
					:data => elements[1].text_value[1..-2]
				}
			end
  end

  def _nt_property_set
    start_index = index
    if node_cache[:property_set].has_key?(index)
      cached = node_cache[:property_set][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_property
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        r3 = _nt_property_bracket
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        r4 = _nt_sp
        s0 << r4
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(PropertySet0)
      r0.extend(PropertySet1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:property_set][start_index] = r0

    return r0
  end

  module PropertyBracket0
  end

  def _nt_property_bracket
    start_index = index
    if node_cache[:property_bracket].has_key?(index)
      cached = node_cache[:property_bracket][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('[', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[')
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3 = index
        if input.index(Regexp.new('[^\\[\\]]'), index) == index
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          r4 = nil
        end
        if r4
          r3 = r4
        else
          r5 = _nt_property_bracket
          if r5
            r3 = r5
          else
            self.index = i3
            r3 = nil
          end
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
      if r2
        if input.index(']', index) == index
          r6 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(']')
          r6 = nil
        end
        s0 << r6
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(PropertyBracket0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:property_bracket][start_index] = r0

    return r0
  end

  module Property0
    def sp
      elements[1]
    end
  end

  def _nt_property
    start_index = index
    if node_cache[:property].has_key?(index)
      cached = node_cache[:property][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    s1, i1 = [], index
    loop do
      if input.index(Regexp.new('[A-Z]'), index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r2 = nil
      end
      if r2
        s1 << r2
      else
        break
      end
    end
    if s1.empty?
      self.index = i1
      r1 = nil
    else
      r1 = SyntaxNode.new(input, i1...index, s1)
    end
    if r1
      r0 = r1
    else
      i3, s3 = index, []
      if input.index(Regexp.new('[A-Z]'), index) == index
        r4 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r4 = nil
      end
      s3 << r4
      if r4
        r5 = _nt_sp
        s3 << r5
      end
      if s3.last
        r3 = (SyntaxNode).new(input, i3...index, s3)
        r3.extend(Property0)
      else
        self.index = i3
        r3 = nil
      end
      if r3
        r0 = r3
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:property][start_index] = r0

    return r0
  end

  def _nt_sp
    start_index = index
    if node_cache[:sp].has_key?(index)
      cached = node_cache[:sp][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if input.index(Regexp.new('[\\r\\n\\t ]'), index) == index
        r1 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = SyntaxNode.new(input, i0...index, s0)

    node_cache[:sp][start_index] = r0

    return r0
  end

end

class SgfGrammarParser < Treetop::Runtime::CompiledParser
  include SgfGrammar
end
