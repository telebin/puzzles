class IntComputator
  def initialize(tape = [99])
    @tape = tape.clone
  end

  def computerize()
    ip = 0
    until @tape[ip] == 99
      a, b, c, op = [@tape[ip] / 10000, @tape[ip] / 1000 % 10, @tape[ip] / 100 % 10, @tape[ip] % 100]
      log "a, b, c, op = [#{a}, #{b}, #{c}, #{op}]"
      case op
      when 1
        log "@tape[#{@tape[ip + 3]}] = #{value(c, ip + 1)} + #{value(b, ip + 2)}"
        @tape[@tape[ip + 3]] = value(c, ip + 1) + value(b, ip + 2)
        ip += 4
      when 2
        log "@tape[#{@tape[ip + 3]}] = #{value(c, ip + 1)} * #{value(b, ip + 2)}"
        @tape[@tape[ip + 3]] = value(c, ip + 1) * value(b, ip + 2)
        ip += 4
      when 3
        puts 'Please enter a value'
        @tape[@tape[ip + 1]] = gets.to_i
        ip += 2
      when 4
        puts "#{value(c, ip + 1)} (ip: #{ip})"
        ip += 2
      when 5
        log "jumping to #{value(b, ip + 2)}: #{!value(c, ip + 1).zero?}"
        ip = !value(c, ip + 1).zero? ? value(b, ip + 2) : ip + 3
      when 6
        log "jumping to #{value(b, ip + 2)}: #{value(c, ip + 1).zero?}"
        ip = value(c, ip + 1).zero? ? value(b, ip + 2) : ip + 3
      when 7
        log "@tape[#{@tape[ip + 3]}] = #{value(c, ip + 1)} < #{value(b, ip + 2)} ? 1 : 0"
        @tape[@tape[ip + 3]] = value(c, ip + 1) < value(b, ip + 2) ? 1 : 0
        ip += 4
      when 8
        log "@tape[#{@tape[ip + 3]}] = #{value(c, ip + 1)} == #{value(b, ip + 2)} ? 1 : 0"
        @tape[@tape[ip + 3]] = value(c, ip + 1) == value(b, ip + 2) ? 1 : 0
        ip += 4
      else
        raise 'bad thing happened'
      end
    end
    @tape
  end

  private

    def value(mode, pos)
      mode == 1 ? @tape[pos] : @tape[@tape[pos]]
    end
end
