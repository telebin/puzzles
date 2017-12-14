require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class String
  def knot_hash
    input = chars.map(&:ord) + [17, 31, 73, 47, 23]
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
        .reduce([]) { |arr, slice| arr << slice.reduce { |a, n| a ^ n } }
        .map { |num| ('0' + num.to_s(16))[-2, 2] }
        .join
  end
end

class Adv14_a < TestFramework
  def logic(t)
    (0..127)
        .map { |i| "#{t}-#{i}" }
        .map(&:knot_hash)
        .map { |h| h.to_i(16).to_s(2) }
        .reduce(0) { |a, v| a + v.count('1') }
  end
end

class Adv14_b < TestFramework
  def logic(t)
    @map = (0..127)
               .map { |i| "#{t}-#{i}" }
               .map(&:knot_hash)
               .map { |h| h.to_i(16).to_s(2) }
               .map { |h| '0' * (128 - h.length) + h }
               .map { |h| h.chars.map { |c| c == '1' } }
    # log @map.map { |r| r.map { |c| c ? '#' : '.' }.join + "\n" }.join
    @last_region = 0
    @map.each_with_index do |row, ri|
      row.each_index { |col_i| flood_region ri, col_i, -1 }
    end
    # log @map.map { |r| r.map { |c| c ? c.to_s(36)[-1] : '.' }.join + "\n" }.join
    @last_region
  end

  def flood_region(y, x, color)
    return unless @map[y][x] === true
    color = @last_region += 1 if color == -1
    @map[y][x] = color
    flood_region y, x - 1, color if x > 0 && @map[y][x - 1] === true
    flood_region y, x + 1, color if @map[y][x + 1] === true
    flood_region y - 1, x, color if y > 0 && @map[y - 1] && @map[y - 1][x] === true
    flood_region y + 1, x, color if @map[y + 1] && @map[y + 1][x] === true
  end
end

adva = Adv14_a.new({ 'flqrgnkx' => 8108 }, 14)
# adva.test
# puts adva.run

advb = Adv14_b.new({ 'flqrgnkx' => 1242 }, 14)
# advb.test
puts advb.run
