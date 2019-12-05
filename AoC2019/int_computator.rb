class IntComputator
  def self.computerize(tape = [99])
    ip = 0
    until tape[ip] == 99
      case tape[ip]
      when 1
        tape[tape[ip + 3]] = tape[tape[ip + 1]] + tape[tape[ip + 2]]
      when 2
        tape[tape[ip + 3]] = tape[tape[ip + 1]] * tape[tape[ip + 2]]
      else
        raise 'bad thing happened'
      end
      ip += 4
    end
    tape
  end
end
