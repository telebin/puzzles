require '../test_framework'

$debug = false

def log(msg)
  STDERR.puts msg.to_s
end

class Adv10_a < TestFramework
  def logic(t)
    list = ($debug ? (0..4) : (0..255)).to_a
    pos = 0
    skip = 0
    input = t.split(',').map(&:to_i)
    input.each do |len|
      len.times
          .reduce([]) { |a, i| a << list[(pos + i) % list.length] }
          .reverse
          .each_with_index { |v, i| list[(pos + i) % list.length] = v }
      pos = (pos + len + skip) % list.length
      skip += 1
    end
    list[0] * list[1]
  end
end

class Adv10_b < TestFramework
  def logic(t)
    input = t.chars.map(&:ord) + [17, 31, 73, 47, 23]
    list = (0..255).to_a
    pos = 0
    skip = 0
    64.times do
      input.each do |len|
        len.times
            .reduce([]) { |a, i| a << list[(pos + i) % list.length] }
            .reverse
            .each_with_index { |v, i| list[(pos + i) % list.length] = v }
        pos = (pos + len + skip) % list.length
        skip += 1
      end
    end
    list.each_slice(16)
        .reduce([]) { |a, slice| a << slice.reduce { |a, n| a ^ n } }
        .map { |num| ('0' + num.to_s(16))[-2, 2] }
        .join
  end
end

adva = Adv10_a.new({
                       '3,4,1,5' => 12
                   }, 10)
# $debug ? adva.test : puts(adva.run)

advb = Adv10_b.new({
                       '' => 'a2582a3a0e66e6e86e3812dcb672a272',
                       'AoC 2017' => '33efeb34ea91902bb2f59c9920caa6cd',
                       '1,2,3' => '3efbe78a8d82f29979031a4aa0b16a9d',
                       '1,2,4' => '63960835bcdc130f0b66d7ff4f6a5a8e'
                   }, 10)
$debug ? advb.test : puts(advb.run)
