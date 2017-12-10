require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Adv11_a < TestFramework
  def logic(t)

  end
end

class Adv11_b < TestFramework
  def logic(t)

  end
end

adva = Adv11_a.new({}, 11)
# adva.test
# puts adva.run

advb = Adv11_b.new({}, 11)
# advb.test
# puts advb.run
