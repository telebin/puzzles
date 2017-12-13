require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Adv14_a < TestFramework
  def logic(t)

  end
end

class Adv14_b < TestFramework
  def logic(t)

  end
end

adva = Adv14_a.new({}, 14)
# adva.test
# puts adva.run

advb = Adv14_b.new({}, 14)
# advb.test
# puts advb.run
