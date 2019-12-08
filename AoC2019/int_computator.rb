class IntComputator

  attr_reader :state

  def initialize(program, input = [])
    @prog = program
    @input = input
    @output = []
    @state = :RUN
    @ip = 0
  end

  def computerize(immediate = nil)
    @state = :RUN
    until @prog[@ip] == 99
      a, b, c, op = [@prog[@ip] / 10000, @prog[@ip] / 1000 % 10, @prog[@ip] / 100 % 10, @prog[@ip] % 100]
      #log "a, b, c, op = [#{a}, #{b}, #{c}, #{op}]"
      case op
      when 1
        #log "@prog[#{@prog[@ip + 3]}] = #{value(c, @ip + 1)} + #{value(b, @ip + 2)}"
        @prog[@prog[@ip + 3]] = value(c, @ip + 1) + value(b, @ip + 2)
        @ip += 4
      when 2
        #log "@prog[#{@prog[@ip + 3]}] = #{value(c, @ip + 1)} * #{value(b, @ip + 2)}"
        @prog[@prog[@ip + 3]] = value(c, @ip + 1) * value(b, @ip + 2)
        @ip += 4
      when 3
        #log "inputting to @prog[#{@prog[@ip + 1]}] = #{@input.empty?} ? #{immediate} : #{@input}"
        @prog[@prog[@ip + 1]] = @input.empty? ? immediate : @input.shift
        @ip += 2
      when 4
        begin
          if immediate
            #log "returning #{value(c, @ip + 1)} (@ip: #{@ip})"
            @state = :OUTPUT
            return [value(c, @ip - 1)]
          else
            #log "adding to output #{value(c, @ip + 1)} (@ip: #{@ip})"
            @output << value(c, @ip + 1)
          end
        ensure
          @ip += 2
        end
      when 5
        #log "jumping to #{value(b, @ip + 2)}: #{!value(c, @ip + 1).zero?}"
        @ip = !value(c, @ip + 1).zero? ? value(b, @ip + 2) : @ip + 3
      when 6
        #log "jumping to #{value(b, @ip + 2)}: #{value(c, @ip + 1).zero?}"
        @ip = value(c, @ip + 1).zero? ? value(b, @ip + 2) : @ip + 3
      when 7
        #log "@prog[#{@prog[@ip + 3]}] = #{value(c, @ip + 1)} < #{value(b, @ip + 2)} ? 1 : 0"
        @prog[@prog[@ip + 3]] = value(c, @ip + 1) < value(b, @ip + 2) ? 1 : 0
        @ip += 4
      when 8
        #log "@prog[#{@prog[@ip + 3]}] = #{value(c, @ip + 1)} == #{value(b, @ip + 2)} ? 1 : 0"
        @prog[@prog[@ip + 3]] = value(c, @ip + 1) == value(b, @ip + 2) ? 1 : 0
        @ip += 4
      else
        raise 'bad thing happened'
      end
    end
    @state = :HALT
    @output
  end

  private

    def value(mode, pos)
      mode == 1 ? @prog[pos] : @prog[@prog[pos]]
    end
end
