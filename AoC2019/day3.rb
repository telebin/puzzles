require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
  # puts msg.to_s
end

DIRS = { R: [1, 0], L: [-1, 0], U: [0, 1], D: [0, -1] }.freeze

class Adv_a < TestFramework
  def logic(t)
    wires = t.split("\n").map { |wire| wire.split(',').map { |step| [step[0].to_sym, step[1..].to_i] } }
    duplicated = make_route(wires[0]) & make_route(wires[1])
    duplicated.map { |x, y| x.abs + y.abs }.reject(&:zero?).min
  end

  private

    def make_route(wire)
      wire.reduce([[0,0]]) do |route, step|
        step[1].times { route << route.last.zip(DIRS[step[0]]).map(&:sum) }
        route
      end
    end
end

class Adv_b < TestFramework
  def logic(t)
    wires = t.split("\n").map { |wire| wire.split(',').map { |step| [step[0].to_sym, step[1..].to_i] } }
    route_a = make_route(wires[0])
    route_b = make_route(wires[1])
    duplicated = route_a & route_b
    duplicated.map {|pos| route_a.find_index(pos) + route_b.find_index(pos)}.reject(&:zero?).min
  end

  private

    def make_route(wire)
      wire.reduce([[0,0]]) do |route, step|
        step[1].times { route << route.last.zip(DIRS[step[0]]).map(&:sum) }
        route
      end
    end
end

adva = Adv_a.new({
                     "R8,U5,L5,D3\nU7,R6,D4,L4" => 6,
                     "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83" => 159,
                     "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7" => 135
                 }, 3)
# adva.test
# puts adva.run

advb = Adv_b.new({
                     "R8,U5,L5,D3\nU7,R6,D4,L4" => 30,
                     "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83" => 610,
                     "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7" => 410
                 }, 3)
advb.test
puts advb.run
