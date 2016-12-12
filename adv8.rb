require './test_framework'

class Adv8_a < TestFramework
  def logic(t)
    @display = Array.new(6) { Array.new(50) { 0 } }
    t.each do |step|
      case step
      when /rect (\d+)x(\d+)/
        rect $1.to_i, $2.to_i
      when /rotate column x=(\d+) by (\d+)/
        rot_col $1.to_i, $2.to_i
      when /rotate row y=(\d+) by (\d+)/
        rot_row $1.to_i, $2.to_i
      else
        raise "Error while parsing '#{step}'"
      end
    end
    puts 'Final screen:'
    @display.each {|e| e.each {|c| printf c == 1 ? '#' : ' ' }; puts }
    @display.flatten.reduce { |v,px| v+px }
  end

  def rot_row y, by
    puts "rot row #{y} by #{by}"
    @display[y].rotate! -by
  end
  def rot_col x, by
    puts "rot col #{x} by #{by}"
    d = @display
    dispcol = d[0][x],d[1][x],d[2][x],d[3][x],d[4][x],d[5][x]
    d[0][x],d[1][x],d[2][x],d[3][x],d[4][x],d[5][x] = dispcol.rotate -by
  end
  def rect x, y
    puts "rect #{x} by #{y}"
    y.times do |yi|
      x.times do |xi|
        @display[yi][xi] = 1
      end
    end
  end
end

class Adv8_b < TestFramework
  def logic(t)

  end
end

tests = Adv8_a.new({['rect 3x2','rotate column x=1 by 1','rotate row y=0 by 4','rotate column x=1 by 1'] => 6})
# tests.test
testsb = Adv8_b.new({})
# testsb.test

File.open('AoC2016_inputs/day8.txt') { |f| $lines = f.readlines }
puts tests.logic $lines
# puts testsb.logic $lines.join("\n")
