require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Adv12_a < TestFramework
  def logic(t)

  end
end

class Adv12_b < TestFramework
  def logic(t)

  end
end

adva = Adv12_a.new({}, 12)
# adva.test
# puts adva.run

advb = Adv12_b.new({}, 12)
# advb.test
# puts advb.run
