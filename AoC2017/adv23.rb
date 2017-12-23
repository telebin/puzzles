require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Adv23Base < TestFramework

  def set(op1, op2)
    @regs[op1] = get_value_from op2
  end

  def sub(op1, op2)
    @regs[op1] = get_value_from(op1) - get_value_from(op2)
  end

  def mul(op1, op2)
    @regs[op1] = get_value_from(op1) * get_value_from(op2)
  end

  def jnz(op1, op2)
    @ip += op2.to_i - 1 unless @regs[op1] == 0
  end

  def parse_operand(operand)
    ('a'..'z').include?(operand) ? operand : operand.to_i if operand
  end

  def get_value_from(operand)
    operand.is_a?(Numeric) ? operand : (@regs[operand] ||= 0)
  end
end
class Adv23_a < Adv23Base
  def logic(t)
    @multd = 0
    @regs = ('a'..'h').reduce({}) { |h, r| h.merge({ r => 0 }) }
    @ip = 0
    @program = t.split("\n").map do |line|
      /([^\s]+)\s([^\s]+)(?:\s([^\s]+))?$/ =~ line
      { op: method($1.to_sym), op1: $2, op2: parse_operand($3) }
    end
    while @ip >= 0 && @ip < @program.length
      @program[@ip][:op].call(@program[@ip][:op1], @program[@ip][:op2])
      @ip += 1
    end
    @multd
  end

  def mul(op1, op2)
    @multd += 1
    @regs[op1] = get_value_from(op1) * get_value_from(op2)
  end
end

class Adv23_b < Adv23Base
  def logic(t)
    h = 0
    b = 109300
    c = b + 17000
    while true
      f = false
      d = 2
      begin
        f = true if b % d == 0
        d += 1
      end until f || d - b == 0
      h += 1 if f
      if b - c == 0
        puts h
        exit
      end
      b += 17
    end
    h
  end
end

adva = Adv23_a.new({}, 23)
# adva.test
# puts adva.run

advb = Adv23_b.new({}, 23)
# advb.test
puts advb.run
