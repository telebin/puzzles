require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Component
  def initialize(description)
    /(\d+)\/(\d+)/ =~ description
    @port0 = $1
    @port1 = $2
  end
end
class Adv24_a < TestFramework
  def logic(t)
    components = t.split("\n").map { |line| Component.new line }

  end
end

class Adv24_b < TestFramework
  def logic(t)

  end
end

adva = Adv24_a.new({"0/2\n2/2\n2/3\n3/4\n3/5\n0/1\n10/1\n9/10\n" => 31}, 24)
# adva.test
# puts adva.run

advb = Adv24_b.new({}, 24)
# advb.test
# puts advb.run
