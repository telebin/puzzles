require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Adv15_a < TestFramework
  def logic(t)

  end
end

class Adv15_b < TestFramework
  def logic(t)

  end
end

adva = Adv15_a.new({}, 15)
# adva.test
# puts adva.run

advb = Adv15_b.new({}, 15)
# advb.test
# puts advb.run
