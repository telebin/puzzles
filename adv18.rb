require './test_framework'

class Adv18_a < TestFramework
  MAX_ROWS = 40
  TRAP = '^'
  SAFE = '.'

  def logic(t)
    input = t.clone
    safe_cnt = 0
    # [t.length, MAX_ROWS].min.times do |iter|
      # puts "#{iter}: #{input}"
    400000.times do
      chars = input.chars
      safe_cnt += chars.reduce(0) { |m, e| m + (e == SAFE ? 1 : 0) }
      input = ''
      ext_chars = [SAFE] + chars + [SAFE]
      (1..chars.size).each do |i|
        input << (determine_trap(ext_chars, i) ? TRAP : SAFE)
      end
    end
    safe_cnt
  end

  def determine_trap(ext_chars, i)
    l = ext_chars[i-1]
    c = ext_chars[i]
    r = ext_chars[i+1]
    trap_cond1 = (l == TRAP and c == TRAP and r != TRAP)
    trap_cond2 = (c == TRAP and r == TRAP and l != TRAP)
    trap_cond3 = (l == TRAP and c == SAFE and r == SAFE)
    trap_cond4 = (r == TRAP and c == SAFE and l == SAFE)
    trap_cond1 or trap_cond2 or trap_cond3 or trap_cond4
  end
end

File.open('AoC2016_inputs/day18.txt') { |f| $line = f.readline }

testa = Adv18_a.new({'..^^.' => 9, '.^^.^.^^^^' => 38})
# testa.test
puts testa.logic $line
