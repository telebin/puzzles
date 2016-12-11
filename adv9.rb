require './test_framework'
require 'stringio'

class Adv9Util
  def self.parse_multiplier(sio)
    to_parse = ''
    until (c = sio.getc) == ')'
      to_parse << c
    end
    /(\d+)x(\d+)/ =~ to_parse
    return $1.to_i, $2.to_i
  end
end

class Adv9_a < TestFramework
  def logic(t)
    sio = StringIO.new t
    result = ''
    while (c = sio.getc)
      if c == '('
        chars, times = Adv9Util.parse_multiplier sio
        result << sio.read(chars) * times
      else
        result << c
      end
    end
    result.length
  end
end

class Adv9_b < TestFramework
  class Compressor
    @times
    @compressed

    def initialize(times, compr_str)
      @times = times
      @compressed = []
      sio = StringIO.new compr_str
      while (c = sio.getc)
        if c == '('
          chars, times = Adv9Util.parse_multiplier sio
          @compressed << Compressor.new(times, sio.read(chars))
        else
          @compressed << c
        end
      end
    end

    def length
      @times * @compressed.map {|e| e.length}.reduce {|m,e| m+e}
    end
  end

  def logic(t)
    Compressor.new(1, t).length
  end
end

tests = Adv9_a.new({'ADVENT' => 6, 'A(1x5)BC' => 7, '(3x3)XYZ' => 9, 'A(2x2)BCD(2x2)EFG' => 11,
                    '(6x1)(1x3)A' => 6, 'X(8x2)(3x3)ABCY' => 18})
# tests.test
testsb = Adv9_b.new({'(3x3)XYZ' => 9, 'X(8x2)(3x3)ABCY' => 20, '(27x12)(20x12)(13x14)(7x10)(1x12)A' => 241920,
                     '(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN' => 445})
testsb.test

File.open('AoC2016_inputs/day9.txt') { |f| $lines = f.readlines }
# puts tests.logic $lines.join("\n").strip
puts testsb.logic $lines.join("\n").strip
