require './test_framework'

DISK_SIZE = 35651584

class Adv16 < TestFramework
  def logic(t)
    input = t.clone
    puts 'Filling disk...'
    input += '0' + input.chars.reverse.map { |c| c == '0' ? '1' : '0' }.join while input.size < DISK_SIZE
    input = input[0, DISK_SIZE].chars
    puts 'Counting checksum...'
    input = input.each_slice(2).map { |l,r| l == r ? '1' : '0' } until input.size.odd?
    input.join
  end
end

testa = Adv16.new({'10000' => '01100'})
# testa.test
puts testa.logic '10111011111001111'
