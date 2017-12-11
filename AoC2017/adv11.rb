require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Adv11Base < TestFramework
  def count_steps(path)
    to_north = 0
    to_east = 0
    path.each do |dir|
      if dir.length == 1
        to_north += (dir == 'n') ? 1 : -1
      else
        to_north += (dir.include? 'n') ? 0.5 : -0.5
        to_east += (dir.include? 'e') ? 1 : -1
      end
    end
    # log "went to: coords #{to_north}N #{to_east}E"
    steps = 0
    until to_east.zero?
      if to_east > 0
        to_east -= 1
        to_north += to_north > 0 ? -0.5 : 0.5
        # log "going west: coords #{to_north}N #{to_east}E"
      else
        to_east += 1
        to_north += to_north > 0 ? -0.5 : 0.5
        # log "going east: coords #{to_north}N #{to_east}E"
      end
      steps += 1
    end
    until to_north.zero?
      to_north += to_north > 0 ? -1 : 1
      steps += 1
    end
    steps
  end
end

class Adv11_a < Adv11Base
  def logic(t)
    count_steps t.split ','
  end
end

class Adv11_b < Adv11Base
  def logic(t)
    input = t.split(',')
    max = 0
    input.size.times do |i|
      counted = count_steps input[0, i + 1]
      # log "counting steps for #{input[0, i + 1]}: #{counted} current max #{max}"
      max = [max, counted].max
    end
    max
  end
end

adva = Adv11_a.new({
                       'ne,ne,ne' => 3,
                       'ne,ne,sw,sw' => 0,
                       'ne,ne,s,s' => 2,
                       'ne,se,ne,se' => 4,
                       'ne,ne,ne,se,ne,se' => 6,
                       'se,sw,se,sw,sw' => 3,
                       'se,se,se,ne,se,ne,nw,nw' => 4
                   }, 11)
# adva.test
# puts adva.run

advb = Adv11_b.new({
                       'ne,ne,ne' => 3,
                       'ne,ne,sw,sw' => 2,
                       'ne,ne,s,s' => 2,
                       'ne,se,ne,se' => 4,
                       'ne,ne,ne,se,ne,se' => 6,
                       'se,sw,se,sw,sw' => 3,
                       'se,se,se,ne,se,ne,nw,nw' => 6
                   }, 11)
advb.test
puts advb.run
