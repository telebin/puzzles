require './test_framework'

class Adv3_a < TestFramework
  def logic(t)
    jea = 0
    t.each do |s|
      edges = s.split.map { |e| e.to_i }.sort
      jea += 1 if edges[0] + edges[1] > edges[2]
    end
    jea
  end
end

class Adv3_b < TestFramework
  def logic(t)
    jea = 0
    arr = []
    t.each do |s|
      arr << s.split.map { |e| e.to_i }
    end
    trans = arr.transpose.flatten.each_slice(3).to_a
    trans.each do |edges|
      edges.sort!
      jea += 1 if edges[0] + edges[1] > edges[2]
    end
    jea
  end
end

tests = Adv3_a.new({['92  413  191','545  626  626','810  679   10','556  616  883'] => 2}, 3)
tests.test
testsb = Adv3_b.new({['92  413  191','545  626  626','810  679   10','556  616  883','638  749  188','981  415  634'] => 3}, 3)
testsb.test

puts tests.run
puts testsb.run
