require '../test_framework'

class ComputR
  def initialize program
    @regs = {:a => 0, :b => 0, :c => 1, :d => 0}
    @ip = 0
    @prog = program
  end

  def run
    while @ip < @prog.size
      case @prog[@ip]
      when /cpy (\d+) (\w)/
        cpy $1.to_i, $2.to_sym
      when /cpy (\w) (\w)/
        cpy $1.to_sym, $2.to_sym
      when /inc (\w)/
        inc $1.to_sym
      when /dec (\w)/
        dec $1.to_sym
      when /jnz (\w) (-?\d+)/
        jnz $1.to_sym, $2.to_i
      else
        raise "Unsupported opcode"
      end
    end
    @regs[:a]
  end

  def cpy rv, reg
    @regs[reg] = rv.class == Fixnum ? rv : @regs[rv]
    @ip += 1
  end
  def inc reg
    @regs[reg] += 1
    @ip += 1
  end
  def dec reg
    @regs[reg] -= 1
    @ip += 1
  end
  def jnz reg, vec
    @ip += @regs[reg] != 0 ? vec : 1
  end
end

class Adv12 < TestFramework
  def logic(t)
    ComputR.new(t).run
  end
end

tests = Adv12.new({['cpy 41 a','inc a','inc a','dec a','jnz a 2','dec a'] => 42}, 12)
# tests.test

File.open('inputs/day12.txt') { |f| $lines = f.readlines }
puts tests.logic $lines
