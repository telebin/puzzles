require './test_framework'

DISK_SIZE = 35651584

class Adv16 < TestFramework
  def logic(t)
    input = t.clone
    while input.size < DISK_SIZE
      input += '0' + input.chars.reverse.map { |c| c == '0' ? '1' : '0' }.join
    end
    # puts "dragonized #{input} len #{input.size}"
    input = input[0, DISK_SIZE]
    # puts "cut #{input} len #{input.size} odd #{input.length.odd?}"
    until input.length.odd?
      chars = input.chars
      input = ''
      while chars.size >= 2
        pair = chars.shift 2
        input += pair[0] == pair[1] ? '1' : '0'
      end
      # puts "sum #{input}"
    end
    input
  end
end

testa = Adv16.new({'10000' => '01100'})
# testa.test
puts testa.logic '10111011111001111'