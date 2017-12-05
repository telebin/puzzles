require '../test_framework'

class Adv5_a < TestFramework
  def logic(t)

  end
end

class Adv5_b < TestFramework
  def logic(t)

  end
end

adva = Adv5_a.new({"0\n3\n0\n1\n-3\n" => 5}, 5)
adva.test
puts adva.run

advb = Adv5_b.new({}, 5)
# advb.test
# puts advb.run
