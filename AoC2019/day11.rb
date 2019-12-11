require '../test_framework'
require_relative 'int_computator'

TURNS = {
    UP: [:LEFT, :RIGHT],
    LEFT: [:DOWN, :UP],
    DOWN: [:RIGHT, :LEFT],
    RIGHT: [:UP, :DOWN]
}.freeze

MOVES = {
    UP: [0, 1],
    RIGHT: [1, 0],
    DOWN: [0, -1],
    LEFT: [-1, 0]
}.freeze

class Adv11_a < TestFramework
  def logic(t)
    computator = IntComputator.new(t.split(',').map(&:to_i))
    pos = [0, 0]
    map = { pos => 0 }
    dir = :UP

    until computator.state == :HALT
      old_col = map[pos].to_i
      map[pos] = computator.computerize(old_col).first
      dir = TURNS[dir][computator.computerize(old_col).first]
      pos = pos.zip(MOVES[dir]).map(&:sum)
      computator.computerize
    end
    map.size
  end
end

class Adv11_b < TestFramework
  def logic(t)
    computator = IntComputator.new(t.split(',').map(&:to_i))
    pos = [0, 0]
    map = { pos => 1 }
    dir = :UP

    until computator.state == :HALT
      old_col = map[pos].to_i
      map[pos] = computator.computerize(old_col).first
      dir = TURNS[dir][computator.computerize(old_col).first]
      pos = pos.zip(MOVES[dir]).map(&:sum)
      computator.computerize
    end
    maxx, maxy = map.keys.reduce { |l, r| [[l[0], r[0]].max, [l[1].abs, r[1].abs].max] }
    buffer = Array.new(maxy + 1) { Array.new(maxx + 1) { ' ' } }
    map.select { |_, color| color == 1 }.each_key { |x, y| buffer[-y][x] = '©' }
    buffer.map(&:join).join "\n"
  end
end

$logging = true
adva = Adv11_a.new({
                   }, 11)
#adva.test
#puts adva.run

advb = Adv11_b.new({
                   }, 11)
puts advb.run
