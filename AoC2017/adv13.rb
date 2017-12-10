require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Adv13_a < TestFramework
  def logic(t)

  end
end

class Adv13_b < TestFramework
  def logic(t)

  end
end

adva = Adv13_a.new({}, 13)
# adva.test
# puts adva.run

advb = Adv13_b.new({}, 13)
# advb.test
# puts advb.run
