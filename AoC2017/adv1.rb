require '../test_framework'

class Adv1_a < TestFramework
  def logic(t)
    (t.chars << t[0]).each_cons(2).reduce(0) do |acc, c|
      c.first == c.last ? acc += c.first.to_i : acc
    end
  end
end

class Adv1_b < TestFramework
  def logic(t)
    input = t.chars
    rot_input = input.last(input.size / 2) + input.first(input.size / 2)
    sum = 0
    input.each_with_index do |ch, idx|
      sum += ch.to_i if ch == rot_input[idx]
    end
    sum
  end
end

File.open('inputs/day1.txt') { |f| $line = f.readline.chomp }

testa = Adv1_a.new({'1122' => 3,
                    '1111' => 4,
                    '1234' => 0,
                    '91212129' => 9
                   }, 3)
# testa.test
# puts testa.run

testb = Adv1_b.new({
                       '1212' => 6,
                       '1221' => 0,
                       '123425' => 4,
                       '123123' => 12,
                       '12131415' => 4
                   }, 3)
testb.test
puts testb.run
