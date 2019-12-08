class IntComputator
  def initialize(program, input = [])
    @prog = program
    @input = input
    @output = []
  end

  def computerize()
    ip = 0
    until @prog[ip] == 99
      a, b, c, op = [@prog[ip] / 10000, @prog[ip] / 1000 % 10, @prog[ip] / 100 % 10, @prog[ip] % 100]
      log "a, b, c, op = [#{a}, #{b}, #{c}, #{op}]"
      case op
      when 1
        log "@tape[#{@prog[ip + 3]}] = #{value(c, ip + 1)} + #{value(b, ip + 2)}"
        @prog[@prog[ip + 3]] = value(c, ip + 1) + value(b, ip + 2)
        ip += 4
      when 2
        log "@tape[#{@prog[ip + 3]}] = #{value(c, ip + 1)} * #{value(b, ip + 2)}"
        @prog[@prog[ip + 3]] = value(c, ip + 1) * value(b, ip + 2)
        ip += 4
      when 3
        @prog[@prog[ip + 1]] = @input.shift
        ip += 2
      when 4
        log "#{value(c, ip + 1)} (ip: #{ip})"
        @output << value(c, ip + 1)
        ip += 2
      when 5
        log "jumping to #{value(b, ip + 2)}: #{!value(c, ip + 1).zero?}"
        ip = !value(c, ip + 1).zero? ? value(b, ip + 2) : ip + 3
      when 6
        log "jumping to #{value(b, ip + 2)}: #{value(c, ip + 1).zero?}"
        ip = value(c, ip + 1).zero? ? value(b, ip + 2) : ip + 3
      when 7
        log "@tape[#{@prog[ip + 3]}] = #{value(c, ip + 1)} < #{value(b, ip + 2)} ? 1 : 0"
        @prog[@prog[ip + 3]] = value(c, ip + 1) < value(b, ip + 2) ? 1 : 0
        ip += 4
      when 8
        log "@tape[#{@prog[ip + 3]}] = #{value(c, ip + 1)} == #{value(b, ip + 2)} ? 1 : 0"
        @prog[@prog[ip + 3]] = value(c, ip + 1) == value(b, ip + 2) ? 1 : 0
        ip += 4
      else
        raise 'bad thing happened'
      end
    end
    @output
  end

  private

    def value(mode, pos)
      mode == 1 ? @prog[pos] : @prog[@prog[pos]]
    end
end
