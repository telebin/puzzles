require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Adv17_a < TestFramework
  def logic(t)
    steps = t.to_i
    buf = [0]
    pos = 0
    2017.times do |t|
      pos = (pos + steps) % buf.length + 1
      buf.insert pos, t + 1
    end
    buf[(pos + 1) % buf.length]
  end
end

class Adv17_b < TestFramework
  def logic(t)
    steps = t.to_i
    pos = 0
    len = 0
    (1..50_000_000).reduce(0) { |pos1, i| (pos = (pos + steps) % (len += 1) + 1) == 1 ? i : pos1 }
  end
end

adva = Adv17_a.new({ '3' => 638 }, 17)
# adva.test
# puts adva.run

advb = Adv17_b.new({}, 17)
# advb.test
puts advb.run
