require '../test_framework'

class Adv3_a < TestFramework
  def logic(t)

  end
end

class Adv3_b < TestFramework
  def logic(t)

  end
end

File.open('inputs/day3.txt') { |f| INPUT = f.read.chomp }

adva = Adv3_a.new({
                      '1' => 0,
                      '12' => 3,
                      '23' => 2,
                      '1024' => 31
                  })
# adva.test
# puts adva.logic INPUT

advb = Adv3_b.new({})
# advb.test
# puts advb.logic INPUT
