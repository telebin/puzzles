require './test_framework'
# STDOUT.sync = true

class Adv19_a < TestFramework
  def logic(t)
    @elves = Array.new(t) { |elf| elf + 1 }
    index = 0
    elves_in_game = t
    while elves_in_game > 1
      index = find_next_elf index
      @elves[index] = false
      elves_in_game -= 1
      index = find_next_elf index
      puts "#{elves_in_game} elves still in game" if elves_in_game % 1000 == 0
    end
    @elves.find { |e| e }
  end
  def find_next_elf index
    begin
      index = (index + 1) % @elves.count
    end until @elves[index]
    index
  end
end

class Adv19_b < TestFramework
  def logic(t)
    @elves = Array.new(t) { |elf| elf + 1 }
    index = 0
    elv_cnt = t
    while elv_cnt > 1
      to_rem = (index + elv_cnt / 2) % elv_cnt
      stealing_elf = @elves[index]
      @elves.delete_at(to_rem)
      elv_cnt = @elves.count
      index = (@elves.find_index(stealing_elf)+1) % elv_cnt
      puts "#{elv_cnt} elves still in game" if elv_cnt % 1000 == 0
    end
    @elves.first
  end
end

testa = Adv19_a.new({5 => 3})
# testa.test
# puts testa.run 3017957

testb = Adv19_b.new({5 => 2, 6 => 3})
# testb.test
puts testb.run 3017957

#  6
#     2
#  3

# [1,2,3,4,5,6] 0 (0+6/2)%6=3 st=1
#   [1,2,3,5,6] 1 (1+5/2)%5=3 st=2
#   [1,2,3,6]   2 (2+4/2)%4=0 st=3
#     [2,3,6]   2 (2+3/2)%3=0 st=6
#     [3,6]     0 (0+2/2)%2=1 st=3
