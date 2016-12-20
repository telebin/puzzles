require './test_framework'
require 'thread'

class Adv15 < TestFramework
  def logic(t)
    @time = 0
    @disks = parse_disks t
    while @time += 1
      advance_positions
      break if check_disks
    end
    @time - 1
  end

  def advance_positions
    @disks.each { |disk| disk[:pos] += 1 }
  end

  def check_disks
    disks = @disks.clone
    disks.count.times do |di|
      return false unless (disks[di][:pos] + di) % disks[di][:slot] == 0
    end
    true
  end

  def parse_disks t
    disks = []
    t.each { |s|
      /Disc #\d+ has (\d+) positions; at time=\d+, it is at position (\d+)\./ =~ s
      disks << {:slot => $1.to_i, :pos => $2.to_i}
    }
    p disks
  end
end

THREADS = 4

class Adv15_threaded < TestFramework
  def logic(t)
    @times = Array.new(THREADS) { 0 }
    THREADS.times do |thr|
      Thread.new {
        disks = parse_disks t, THREADS - thr
        time = -thr
        @times[thr] = while time += THREADS
          break time - 1 if check_disks(disks.clone)
          advance_positions disks, THREADS
        end
      }
    end
    sleep 0.5
    until @times.select {|e| e != 0}.min
      p @times
      sleep 0.5
    end
    @times.select {|e| e != 0}.min
  end

  def advance_positions disks, by = 1
    disks.each { |disk| disk[:pos] += by }
  end

  def check_disks disks
    disks.count.times do |di|
      return false unless (disks[di][:pos] + di) % disks[di][:slot] == 0
    end
    true
  end

  def parse_disks t, handicap
    disks = []
    t.each { |s|
      /Disc #\d+ has (\d+) positions; at time=\d+, it is at position (\d+)\./ =~ s
      disks << {:slot => $1.to_i, :pos => $2.to_i + handicap}
    }
    disks
  end

end

File.open('AoC2016_inputs/day15.txt') { |f| $lines = f.readlines }

testa = Adv15_threaded.new({['Disc #1 has 5 positions; at time=0, it is at position 4.','Disc #2 has 2 positions; at time=0, it is at position 1.'] => 5}, 15)
# testa.test
# puts testa.run
puts(testa.run($lines << 'Disc #6 has 11 positions; at time=0, it is at position 0.'))
