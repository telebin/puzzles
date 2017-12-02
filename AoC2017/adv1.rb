require '../test_framework'

class Adv1 < TestFramework
  def logic(t)
    (t.chars << t[0]).each_cons(2).reduce(0) do |acc, c|
      c.first == c.last ? acc += c.first.to_i : acc
    end
  end
end

File.open('inputs/day1.txt') { |f| $line = f.readline.chomp }

tests = Adv1.new({'1122' => 3,
                  '1111' => 4,
                  '1234' => 0,
                  '91212129' => 9,
                 })
# tests.test
puts tests.logic $line
