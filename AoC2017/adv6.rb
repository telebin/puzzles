require '../test_framework'

class Adv6_a < TestFramework
  def logic(t)
    banks = t.split.map(&:to_i)
    # puts "split #{banks}"
    it = 0
    prev_states = []
    until prev_states.include? banks
      idx = banks.find_index banks.max
      prev_states << banks.dup
      it += 1
      max = banks.max
      banks[idx] = 0
      max.times { |i| banks[(i + 1 + idx) % banks.count] += 1 }
      # puts "after #{it} prevs #{prev_states} banks #{banks} max #{max}"
    end
    it
  end
end

class Adv6_b < TestFramework
  def logic(t)
    banks = t.split.map(&:to_i)
    it = 0
    prev_states = []
    until prev_states.include? banks
      idx = banks.find_index banks.max
      prev_states << banks.dup
      it += 1
      max = banks.max
      banks[idx] = 0
      max.times { |i| banks[(i + 1 + idx) % banks.count] += 1 }
    end
    prev_states.size - prev_states.find_index(banks)
  end
end

adva = Adv6_a.new({ "0\t2\t7\t0\n" => 5 }, 6)
# adva.test
adva.run

advb = Adv6_b.new({ "0\t2\t7\t0\n" => 4 }, 6)
# advb.test
# puts advb.run
