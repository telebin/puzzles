require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
  # puts msg.to_s
end

class Adv_a < TestFramework
  def logic(t)
    tape = t.split(',').map(&:to_i)
    unless $test
      tape[1] = 12
      tape[2] = 2
    end
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
    tape.first
  end
end

class Adv_b < TestFramework
  def logic(t)
    counter = 0
    begin
      tape = t.split(',').map(&:to_i)
      tape[1] = counter / 100
      tape[2] = counter % 100
      ip = 0
      until tape[ip] == 99
        # log "noun,verb=#{[counter/100,counter%100]}(#{counter}) ip=#{ip} tape[#{tape[ip + 1]}]=#{tape[tape[ip + 1]]} +*=#{tape[ip]} tape[#{tape[ip + 2]}]=#{tape[tape[ip + 2]]}"
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
      counter += 1
    end until tape.first == 19690720

    tape[0..2]
  end
end

adva = Adv_a.new({
                     '1,9,10,3,2,3,11,0,99,30,40,50' => 3500,
                     '1,0,0,0,99' => 2,
                     '2,3,0,3,99' => 2,
                     '2,4,4,5,99,0' => 2,
                     '1,1,1,4,99,5,6,0,99' => 30
                 }, 2)
# adva.test
# puts adva.run

p Adv_b.new({}, 2).run
