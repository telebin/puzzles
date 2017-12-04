require '../test_framework'

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

    def self.next_dir
      DOWN
    end
  end
  class DOWN < Direction
    def self.value
      [0, -1]
    end

    def self.next_dir
      RIGHT
    end
  end
  class RIGHT < Direction
    def self.value
      [1, 0]
    end

    def self.next_dir
      UP
    end
  end
  class UP < Direction
    def self.value
      [0, 1]
    end

    def self.next_dir
      LEFT
    end
  end
end

class Grid
  def initialize(up_to)
    @pos = [0, 0]
    @dir = Dir::DOWN
    @mem = []
    @map = {}
    up_to.times do |it|
      @mem[it] = @pos
      @map[@pos] = it
      unless @map[@dir.next_dir.next_pos(@pos)]
        @dir = @dir.next_dir
      end
      @pos = @dir.next_pos @pos
    end
    # puts "after all: mem #{@mem} map #{@map} pos #{@pos} dir #{@dir}"
  end

  def pos_of(loc)
    @mem[loc - 1]
  end
end

class Adv3_a < TestFramework
  def logic(t)
    grid = Grid.new t.to_i
    grid.pos_of(t.to_i)[0].abs + grid.pos_of(t.to_i)[1].abs
  end
end

class Adv3_b < TestFramework
  def logic(t)

  end
end

adva = Adv3_a.new({
                      '1' => 0,
                      '12' => 3,
                      '23' => 2,
                      '1024' => 31
                  }, 3)
adva.test
puts adva.run

advb = Adv3_b.new({}, 3)
# advb.test
# puts advb.logic INPUT
