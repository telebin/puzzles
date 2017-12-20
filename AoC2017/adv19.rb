require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Dir
  class Direction
    def self.next_pos(pos)
      [pos[0] + value[0], pos[1] + value[1]]
    end
  end

  class LEFT < Direction
    def self.value
      [-1, 0]
    end

    def self.l
      DOWN
    end

    def self.r
      UP
    end

  end
  class DOWN < Direction
    def self.value
      [0, 1]
    end

    def self.l
      RIGHT
    end

    def self.r
      LEFT
    end
  end
  class RIGHT < Direction
    def self.value
      [1, 0]
    end

    def self.l
      UP
    end

    def self.r
      DOWN
    end
  end
  class UP < Direction
    def self.value
      [0, -1]
    end

    def self.l
      LEFT
    end

    def self.r
      RIGHT
    end
  end
end

class Adv19_a < TestFramework
  def logic(t)
    @map = t.split("\n").map(&:chars)
    pos = [@map[0].find_index('|'), 0]
    dir = Dir::DOWN
    eol = false
    found = []
    until eol
      pos = dir.next_pos(pos)
      x, y = pos
      if @map[y][x] == '|' || @map[y][x] == '-'
        next
      elsif @map[y][x] == '+'
        lx, ly = dir.l.next_pos(pos)
        rx, ry = dir.r.next_pos(pos)
        dir = dir.l if @map[ly] && @map[ly][lx] != ' '
        dir = dir.r if @map[ry] && @map[ry][rx] != ' '
      elsif @map[y][x] == ' '
        eol = true
      else
        raise "Eroror" unless @map[y][x]
        found << @map[y][x]
      end
    end
    found.join
  end
end

class Adv19_b < TestFramework
  def logic(t)
    @map = t.split("\n").map(&:chars)
    pos = [@map[0].find_index('|'), 0]
    dir = Dir::DOWN
    eol = false
    found = 0
    until eol
      pos = dir.next_pos(pos)
      x, y = pos
      found+=1
      if @map[y][x] == '|' || @map[y][x] == '-'
        next
      elsif @map[y][x] == '+'
        lx, ly = dir.l.next_pos(pos)
        rx, ry = dir.r.next_pos(pos)
        dir = dir.l if @map[ly] && @map[ly][lx] != ' '
        dir = dir.r if @map[ry] && @map[ry][rx] != ' '
      elsif @map[y][x] == ' '
        eol = true
      end
    end
    found
  end
end

adva = Adv19_a.new({
"     |          \n"+
"     |  +--+    \n"+
"     A  |  C    \n"+
" F---|----E|--+ \n"+
"     |  |  |  D \n"+
"     +B-+  +--+ \n" => 'ABCDEF'
                   }, 19)
# adva.test
# puts adva.run

advb = Adv19_b.new({
                       "     |          \n"+
                           "     |  +--+    \n"+
                           "     A  |  C    \n"+
                           " F---|----E|--+ \n"+
                           "     |  |  |  D \n"+
                           "     +B-+  +--+ \n" => 38
                   }, 19)
advb.test
puts advb.run
