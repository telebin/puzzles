require './test_framework'

class Adv8_a < TestFramework
  def logic(t)
    
  end
end

class Adv8_b < TestFramework
  def logic(t)

  end
end

tests = Adv8_a.new({})
tests.test
# testsb = Adv8_b.new({})
# testsb.test

File.open('AoC2016_inputs/day8.txt') { |f| $lines = f.readlines }
# puts tests.logic $lines.join("\n").strip
# puts testsb.logic $lines.join("\n").strip
