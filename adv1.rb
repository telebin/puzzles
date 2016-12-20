require './test_framework'

class Adv1_a < TestFramework
  def logic(t)
    d = [0, 0, 0, 0]
    dir = 1
    t[0].split(/\W+/).each { |step|
      dir = (dir + (step[0] == 'R' ? 1 : -1)) % 4
      d[dir] += step[1..(step.length)].to_i
    }
    [d[0], d[2]].max - [d[0], d[2]].min + [d[1], d[3]].max - [d[1], d[3]].min
  end
end

class Adv1_b < TestFramework

  def logic(t)
    dir = 1
    dirs = [0, 0, 0, 0]
    points = [[0, 0]]
    t[0].split(/\W+/).each { |st|
      dir = (dir + (st[0] == 'R' ? 1 : -1)) % 4
      st[1..st.length].to_i.times do
        dirs[dir] += 1
        point = [dirs[2] - dirs[0], dirs[1] - dirs[3]]
        puts "Visited twice: #{point.to_s} (#{(point[0].abs + point[1].abs)})" if points.include? point
        points << point
      end
    }
    points.last[0].abs + points.last[1].abs
  end
end


testa = Adv1_a.new({'R2, L3' => 5, 'R2, R2, R2' => 2, 'R5, L5, R5, R3' => 12,
                    'R1, L3, R5, R5, R5, L4, R5, R1, R2, L1, L1, R5, R1, L3, L5, L2, R4, L1, R4, R5, L3, R5, L1, R3, L5, R1, L2, R1, L5, L1, R1, R4, R1, L1, L3, R3, R5, L3, R4, L4, R5, L5, L1, L2, R4, R3, R3, L185, R3, R4, L5, L4, R48, R1, R2, L1, R1, L4, L4, R77, R5, L2, R192, R2, R5, L4, L5, L3, R2, L4, R1, L5, R5, R4, R1, R2, L3, R4, R4, L2, L4, L3, R5, R4, L2, L1, L3, R1, R5, R5, R2, L5, L2, L3, L4, R2, R1, L4, L1, R1, R5, R3, R3, R4, L1, L4, R1, L2, R3, L3, L2, L1, L2, L2, L1, L2, R3, R1, L4, R1, L1, L4, R1, L2, L5, R3, L5, L2, L2, L3, R1, L4, R1, R1, R2, L1, L4, L4, R2, R2, R2, R2, R5, R1, L1, L4, L5, R2, R4, L3, L5, R2, R3, L4, L1, R2, R3, R5, L2, L3, R3, R1, R3' => 298}, 1)
testb = Adv1_b.new({'R8, R4, R4, R8' => 8,
                    'R1, L3, R5, R5, R5, L4, R5, R1, R2, L1, L1, R5, R1, L3, L5, L2, R4, L1, R4, R5, L3, R5, L1, R3, L5, R1, L2, R1, L5, L1, R1, R4, R1, L1, L3, R3, R5, L3, R4, L4, R5, L5, L1, L2, R4, R3, R3, L185, R3, R4, L5, L4, R48, R1, R2, L1, R1, L4, L4, R77, R5, L2, R192, R2, R5, L4, L5, L3, R2, L4, R1, L5, R5, R4, R1, R2, L3, R4, R4, L2, L4, L3, R5, R4, L2, L1, L3, R1, R5, R5, R2, L5, L2, L3, L4, R2, R1, L4, L1, R1, R5, R3, R3, R4, L1, L4, R1, L2, R3, L3, L2, L1, L2, L2, L1, L2, R3, R1, L4, R1, L1, L4, R1, L2, L5, R3, L5, L2, L2, L3, R1, L4, R1, R1, R2, L1, L4, L4, R2, R2, R2, R2, R5, R1, L1, L4, L5, R2, R4, L3, L5, R2, R3, L4, L1, R2, R3, R5, L2, L3, R3, R1, R3' => 298}, 1)
# testa.test
# testb.test

puts testa.run
puts testb.run 
