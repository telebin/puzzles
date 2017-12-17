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
      @dir = @dir.next_dir unless @map[@dir.next_dir.next_pos(@pos)]
      @pos = @dir.next_pos @pos
    end
    # puts "after all: mem #{@mem} map #{@map} pos #{@pos} dir #{@dir}"
  end

  def pos_of(loc)
    @mem[loc - 1]
  end
end

class NeighbouringGrid
  def initialize(up_to)
    @pos = [0, 0]
    @dir = Dir::DOWN
    @map = { @pos => 1 }
    begin
      @dir = @dir.next_dir unless @map[@dir.next_dir.next_pos(@pos)]
      @pos = @dir.next_pos @pos
      written = get_value_to_write
      @map[@pos] = written
      # puts "writing #{written} @ #{@pos}"
      # puts "map now is #{@map}"
    end while written <= up_to
    # puts "after all: mem #{@mem} map #{@map} pos #{@pos} dir #{@dir}"
  end

  def get_value_to_write
    next_l = @map[Dir::LEFT.next_pos(@pos)].to_i
    next_r = @map[Dir::RIGHT.next_pos(@pos)].to_i
    next_u = @map[Dir::UP.next_pos(@pos)].to_i
    next_d = @map[Dir::DOWN.next_pos(@pos)].to_i
    next_lu = @map[Dir::UP.next_pos(Dir::LEFT.next_pos(@pos))].to_i
    next_ld = @map[Dir::DOWN.next_pos(Dir::LEFT.next_pos(@pos))].to_i
    next_ru = @map[Dir::UP.next_pos(Dir::RIGHT.next_pos(@pos))].to_i
    next_rd = @map[Dir::DOWN.next_pos(Dir::RIGHT.next_pos(@pos))].to_i

    # puts "next_l pos #{Dir::LEFT.next_pos(@pos)} => #{next_l}"
    # puts "next_r pos #{Dir::RIGHT.next_pos(@pos)} => #{next_r}"
    # puts "next_u pos #{Dir::UP.next_pos(@pos)} => #{next_u}"
    # puts "next_d pos #{Dir::DOWN.next_pos(@pos)} => #{next_d}"
    # puts "next_lu pos #{Dir::UP.next_pos(Dir::LEFT.next_pos(@pos))} => #{next_lu}"
    # puts "next_ld pos #{Dir::DOWN.next_pos(Dir::LEFT.next_pos(@pos))} => #{next_ld}"
    # puts "next_ru pos #{Dir::UP.next_pos(Dir::RIGHT.next_pos(@pos))} => #{next_ru}"
    # puts "next_rd pos #{Dir::DOWN.next_pos(Dir::RIGHT.next_pos(@pos))} => #{next_rd}"
    next_l + next_r + next_u + next_d + next_lu + next_ld + next_ru + next_rd
  end

  def current_value
    @map[@pos]
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
    grid = NeighbouringGrid.new t.to_i
    grid.current_value
  end
end

adva = Adv3_a.new({
                      '1' => 0,
                      '12' => 3,
                      '23' => 2,
                      '1024' => 31
                  }, 3)
# adva.test
# puts adva.run

advb = Adv3_b.new({
                      '5' => 10,
                      '1' => 2,
                      '54' => 57,
                      '200' => 304
                  }, 3)
advb.test
puts advb.run
