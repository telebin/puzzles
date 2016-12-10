require './test_framework'

class Adv4Base < TestFramework
  def get_name_and_sector(t)
    sector_match = /\d+/.match t
    sector = sector_match[0]
    room_name = t[0, sector_match.begin(0)-1]
    chksum = /\[\w+\]/.match(t)[0][1..-2]
    calc_sum = room_name.chars.group_by { |e| e }
                   .inject([]) { |m, e| m[e[1].size] = (m[e[1].size] or []) << e[0]; m }
                   .map { |e| e ? e.sort.reverse : [] }.flatten.keep_if { |e| e =~ /\w/ }.reverse[0, 5].join
    return room_name, calc_sum == chksum ? sector.to_i : 0
  end
end

class Adv4_a < Adv4Base
  def logic(t)
    get_name_and_sector(t)[1]
  end
end

# noinspection RubyUnnecessaryReturnStatement
class Adv4_b < Adv4Base
  def logic(t)
    alph = ('a'..'z').to_a
    alph_s = alph.size
    name, sector = get_name_and_sector t
    if sector == 0
      return false
    else
      return name.chars.map do |c|
        c != '-' ? alph[(alph.find_index(c)+sector)%alph_s] : ' '
      end.join + ' - ' + sector.to_s
    end
  end
end
# TODO 6 a lub b i 9 a/b!
tests = Adv4_a.new({'aaaaa-bbb-z-y-x-123[abxyz]' => 123, 'a-b-c-d-e-f-g-h-987[abcde]' => 987,
                    'not-a-real-room-404[oarel]' => 404, 'totally-real-room-200[decoy]' => 0})
# tests.test
testsb = Adv4_b.new({'qzmt-zixmtkozy-ivhz-343[zimth]' => 'very encrypted name'})
testsb.test

sector_sum = 0
File.open('AoC2016_inputs/day4.txt') { |f|
  $lines = f.readlines
}
# $lines.each { |l|
#   sector_sum += tests.logic l
# }
# puts sector_sum
$lines.each { |l|
  a = testsb.logic l
  puts a if a
}