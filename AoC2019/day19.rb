require '../test_framework'
require 'io/console'
require_relative 'int_computator'

TILES = %w(. × •)

def print_map(map)
  maxx, maxy = map.keys.reduce { |l, r| [[l[0], r[0]].max, [l[1].abs, r[1].abs].max] }
  buffer = Array.new(maxy + 1) { Array.new(maxx + 1) }
  map.each { |xy, id| buffer[xy[1]][xy[0]] = TILES[id] }
  puts buffer.map(&:join).join "\n"
end

class Adv19_a < TestFramework
  def logic(t)
    map = Array.new(50) { |i| Array.new(50) { |j| [i, j] } }.flatten(1).map do |xy|
      [xy, IntComputator.new(t.split(',').map(&:to_i), xy.clone).computerize.first]
    end.to_h
    print_map map
    map.values.reject(&:zero?).count
  end
end

class Adv19_b < TestFramework
  def logic(t)
    @program = t.split(',').map(&:to_i)
    cx, cy = (0..).step(0.2).lazy.map {|t| [(t * 1.5).round, t.round]}.uniq.map do |x, y|
      #log "[x,y] #{[x, y]}"
      diagonal = diagonal_points(x, y)
      #log "diagonal #{diagonal}\ndiagonal.size #{diagonal.size}"
      diagonal.size >= 100 ? diagonal.reduce { |(ax, ay), (dx, dy)| [[ax, dx].min, [ay, dy].min] } : nil
    end.find { |n| !n.nil? }
    cx * 10000 + cy
  end

  private

    def diagonal_points(x, y)
      (0..).lazy.map { |i| [x + i, y - i] }.take_while { |xy| computerize(xy.clone) == 1 }
          .chain((1..).lazy.map { |i| [x - i, y + i] }.take_while { |xy| computerize(xy.clone) == 1 })
          .to_a
    end

    def computerize(input)
      IntComputator.new(@program.clone, input).computerize.first
    end
end

$logging = true
adva = Adv19_a.new({
                   }, 19)
#adva.test
#p adva.run

advb = Adv19_b.new({
                   }, 19)
p advb.run
