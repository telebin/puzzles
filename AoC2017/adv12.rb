require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Program

  attr_accessor :color
  attr_reader :id, :neighbours

  def initialize(line)
    /(?<id>\d+) <-> (?<neigh>.+)/ =~ line
    @id = id.to_i
    @neighbours = neigh.split(',').map(&:to_i)
    # log "Produced program #{@id} #{@neighbours}"
  end
end

class Adv12Base < TestFramework
  def colorize(prog, color = 0)
    # log "coloring #{prog}"
    prog.color = color
    prog.neighbours.map { |neigh_id| @programs[neigh_id] }.select { |p| !p.color }.each { |neigh| colorize neigh, color }
  end
end

class Adv12_a < Adv12Base
  def logic(t)
    @programs = t.split("\n").map { |line| Program.new line }.reduce([]) { |arr, prog| arr[prog.id] = prog; arr }
    colorize @programs[0]
    @programs.select { |prog| prog.color }.count
  end
end

class Adv12_b < Adv12Base
  def logic(t)
    @programs = t.split("\n").map { |line| Program.new line }.reduce([]) { |arr, prog| arr[prog.id] = prog; arr }
    @programs.lazy.select { |prog| !prog.color }.each { |prog|
      colorize prog, (Random::rand * 0xffffffff).to_i
    }
    @programs.group_by { |prog| prog.color }.count
  end
end

adva = Adv12_a.new({ '0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5' => 6
                   }, 12)
# adva.test
# puts adva.run

advb = Adv12_b.new({ '0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5' => 2 }, 12)
advb.test
puts advb.run
