require '../test_framework'

class Instruction

  attr_reader :op, :cond_reg, :cond_val, :cond, :reg, :val

  def initialize(reg, op, val, cond_reg, cond, cond_val)
    @reg = reg.to_sym
    @sign = op == 'dec' ? -1 : 1
    @val = val.to_i
    @cond_reg = cond_reg.to_sym
    @cond = cond.to_sym
    @cond_val = cond_val.to_i
  end

  def modify(regs)
    reg = regs[@reg] ||= 0
    regs[@reg] = reg + @sign * @val if condition_passes regs
  end

  def condition_passes(regs)
    cond_reg = regs[@cond_reg] ||= 0
    case @cond
      when :==
        cond_reg == @cond_val
      when :!=
        cond_reg != @cond_val
      when :<
        cond_reg < @cond_val
      when :<=
        cond_reg <= @cond_val
      when :>=
        cond_reg >= @cond_val
      when :>
        cond_reg > @cond_val
      else
        raise 'invalid condition'
    end
  end
end

class Adv8_a < TestFramework
  def logic(t)
    instructions = t.split("\n").map do |line|
      /^(\w+) (inc|dec) (-?\d+) if (\w+) (<=?|>=?|!=|==) (-?\d+)$/ =~ line
      Instruction.new $1, $2, $3, $4, $5, $6
    end
    registers = {}
    instructions.each { |instr| instr.modify registers }
    registers.values.max
  end
end

class Adv8_b < TestFramework
  def logic(t)

  end
end

adva = Adv8_a.new({
                      "b inc 5 if a > 1\na inc 1 if b < 5\nc dec -10 if a >= 1\nc inc -20 if c == 10" => 1
                  }, 8)
adva.test
puts adva.run

advb = Adv8_b.new({}, 8)
# advb.test
# puts advb.run
