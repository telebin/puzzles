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

    def self.b
      RIGHT
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

    def self.b
      UP
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

    def self.b
      LEFT
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

    def self.b
      DOWN
    end
  end
end

class Adv22_a < TestFramework
  def logic(t)
    @map = {}
    lines = t.split("\n")
    lines.each_with_index { |line, y| line.chars.each_with_index { |char, x| @map[[x, y]] = (char == '#') } }
    @pos = [lines.count / 2, lines.count / 2]
    # log "pos: #{@pos}, map: #{@map}"
    @dir = Dir::UP
    infected = 0
    10000.times do
      @dir = (@map[@pos] ? @dir.r : @dir.l)
      @map[@pos] = (@map[@pos] ? false : (infected += 1; true))
      @pos = @dir.next_pos @pos
    end
    infected
  end
end

class Adv22_b < TestFramework
  def logic(t)
    @map = {}
    lines = t.split("\n")
    lines.each_with_index { |line, y| line.chars.each_with_index { |char, x| @map[[x, y]] = (char == '#' ? 2 : 0) } }
    @pos = [lines.count / 2, lines.count / 2]
    @dir = Dir::UP
    infected = 0
    1e7.to_i.times do |i|
      @dir = ((@map[@pos] ||= 0) % 2 == 0 ? (@map[@pos] == 0 ? @dir.l : @dir.r) : (@map[@pos] == 1 ? @dir : @dir.b))
      @map[@pos] = (@map[@pos] + 1) % 4
      infected += 1 if @map[@pos] == 2
      @pos = @dir.next_pos @pos
      log "#{i / 10_000_0.0}%, map positions #{@map.length}" if i % 10000 == 0
    end
    infected
  end
end

adva = Adv22_a.new({ "..#\n#..\n..." => 5587 }, 22)
# adva.test
# puts adva.run

advb = Adv22_b.new({ "..#\n#..\n..." => 2511944 }, 22)
# advb.test
puts advb.run
