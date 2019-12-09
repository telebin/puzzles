class IntComputator

  attr_reader :state

  def initialize(program, input = [])
    @prog = program
    @input = input
    @output = []
    @state = :RUN
    @rela_b = 0
    @ip = 0
  end

  def computerize(immediate = nil)
    @state = :RUN
    until @prog[@ip] == 99
      a, b, c, op = [@prog[@ip] / 10000, @prog[@ip] / 1000 % 10, @prog[@ip] / 100 % 10, @prog[@ip] % 100]
      log "a, b, c, op = [#{a}, #{b}, #{c}, #{op}] (@ip #{@ip})"
      case op
      when 1
        #log "[add #{@prog[@ip+1]} #{@prog[@ip+2]} #{@prog[@ip+3]}]: @prog[#{woffset(a, 3)}] = #{value(c, 1)} + #{value(b, 2)}"
        @prog[woffset(a, 3)] = value(c, 1) + value(b, 2)
        @ip += 4
      when 2
        #log "[mul #{@prog[@ip+1]} #{@prog[@ip+2]} #{@prog[@ip+3]}]: @prog[#{woffset(a, 3)}] = #{value(c, 1)} * #{value(b, 2)}"
        @prog[woffset(a, 3)] = value(c, 1) * value(b, 2)
        @ip += 4
      when 3
        log "[inp #{@prog[@ip+1]}]: inputting to @prog[#{woffset(c, 1)}] = #{@input.empty?} ? #{immediate} : #{@input}"
        @prog[woffset(c, 1)] = @input.empty? ? immediate : @input.shift
        @ip += 2
      when 4
        begin
          if immediate
            #log "[out #{@prog[@ip+1]}]: returning #{value(c, 1)} (@ip: #{@ip})"
            @state = :OUTPUT
            return [value(c, 1)]
          else
            log "[out #{@prog[@ip+1]}]: adding to output #{value(c, 1)} (@ip: #{@ip})"
            @output << value(c, 1)
          end
        ensure
          @ip += 2
        end
      when 5
        log "[jnz #{@prog[@ip+1]} #{@prog[@ip+2]}]: jumping to #{value(b, 2)}: #{!value(c, 1).zero?}"
        @ip = !value(c, 1).zero? ? value(b, 2) : @ip + 3
      when 6
        log "[jz #{@prog[@ip+1]} #{@prog[@ip+2]}]: jumping to #{value(b, 2)}: #{value(c, 1).zero?}"
        @ip = value(c, 1).zero? ? value(b, 2) : @ip + 3
      when 7
        log "[lt #{@prog[@ip+1]} #{@prog[@ip+2]} #{@prog[@ip+3]}]: @prog[#{woffset(a, 3)}] = #{value(c, 1)} < #{value(b, 2)} ? 1 : 0"
        @prog[woffset(a, 3)] = value(c, 1) < value(b, 2) ? 1 : 0
        @ip += 4
      when 8
        log "[cmp #{@prog[@ip+1]} #{@prog[@ip+2]} #{@prog[@ip+3]}]: @prog[#{woffset(a, 3)}] = #{value(c, 1)} == #{value(b, 2)} ? 1 : 0"
        @prog[woffset(a, 3)] = value(c, 1) == value(b, 2) ? 1 : 0
        @ip += 4
      when 9
        log "[setr #{@prog[@ip+1]}]: #{@rela_b} += #{value(c, 1)}"
        @rela_b += value(c, 1)
        @ip += 2
      else
        raise 'bad thing happened'
      end
    end
    @state = :HALT
    @output
  end

  private

    def woffset(mode, value)
      case mode
      when 0; @prog[@ip + value]
      when 2; @rela_b + @prog[@ip + value]
      else raise 'invalid write offset mode'
      end
    end

    def value(mode, offset)
      case mode
      when 0; @prog[@prog[@ip + offset]]
      when 1; @prog[@ip + offset]
      when 2; @prog[@rela_b + @prog[@ip + offset]]
      else raise 'invalid value mode'
      end.to_i
    end
end
