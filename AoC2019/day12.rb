require '../test_framework'
require_relative 'int_computator'

class Adv12_a < TestFramework
  def logic(t)
    positions = t.split("\n").map { |l| l =~ /<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/; [$1.to_i, $2.to_i, $3.to_i] }
    velocities = Array.new(4) { Array.new(3) { 0 } }
    $steps.times do
      velocities = velocities.zip(positions.map do |x1, y1, z1|
        positions.map do |x2, y2, z2|
          [v(x1, x2), v(y1, y2), v(z1, z2)]
        end.transpose.map(&:sum)
      end).map { |l, r| l.zip(r).map(&:sum) }
      positions = positions.zip(velocities).map { |l, r| l.zip(r).map(&:sum) }
      #log velocities
      #log positions
    end
    positions.map {|a| a.map(&:abs).sum }.zip(velocities.map {|a| a.map(&:abs).sum }).map {|l,r| l*r}.sum
  end

  private

    def v(x1, x2)
      x1 > x2 ? -1 : x1 < x2 ? 1 : 0
    end
end

class Adv12_b < TestFramework
  def logic(t)
    program = t.split(',').map(&:to_i)
    IntComputator.new(program, [2]).computerize.join ','
  end
end

#$logging = true
$steps = 100
adva = Adv12_a.new({
                       "<x=-1, y=0, z=2>\n<x=2, y=-10, z=-7>\n<x=4, y=-8, z=8>\n<x=3, y=5, z=-1>" => 293,
                       "<x=-8, y=-10, z=0>\n<x=5, y=5, z=10>\n<x=2, y=-7, z=3>\n<x=9, y=-8, z=-3>" => 1940
                   }, 12)
adva.test
$steps = 1000
puts adva.run

advb = Adv12_b.new({
                   }, 12)
#puts advb.run
