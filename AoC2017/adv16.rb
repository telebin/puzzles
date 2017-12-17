require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Array
  def swap!(l, r)
    unless l.kind_of?(Numeric) || r.kind_of?(Numeric)
      l = find_index(l)
      r = find_index(r)
    end
    tmp = self[l]
    self[l] = self[r]
    self[r] = tmp
  end
end

class Adv16_a < TestFramework
  def logic(t)
    instructions = t.split(',')
    dancers = ('a'..'p').to_a
    instructions.each do |instr|
      case instr[0]
        when 's'
          spin = instr[1, instr.length].to_i
          dancers = (dancers * 2)[dancers.count - spin, dancers.count]
        when 'x'
          /(\d+)\/(\d+)/ =~ instr
          dancers.swap! $1.to_i, $2.to_i
        when 'p'
          /(\w)\/(\w)/ =~ instr
          dancers.swap! $1, $2
        else
          raise 'invalid op'
      end
    end
    dancers.join
  end
end

class Adv16_b < TestFramework
  def logic(t)
    instructions = t.split(',')
    dancers = ('a'..'p').to_a
    496.times do
      instructions.each do |instr|
        case instr[0]
          when 's'
            spin = instr[1, instr.length].to_i
            dancers = (dancers * 2)[dancers.count - spin, dancers.count]
          when 'x'
            /(\d+)\/(\d+)/ =~ instr
            dancers.swap! $1.to_i, $2.to_i
          when 'p'
            /(\w)\/(\w)/ =~ instr
            dancers.swap! $1, $2
          else
            raise 'invalid op'
        end
      end
    end
    dancers.join
  end
end

adva = Adv16_a.new({}, 16)
# adva.test
# puts adva.run

advb = Adv16_b.new({}, 16)
# advb.test
puts advb.run
