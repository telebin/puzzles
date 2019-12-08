require '../test_framework'
require_relative 'int_computator'

class Adv5_a < TestFramework
  def logic(t)
    (p IntComputator.new(t.split(',').map(&:to_i), [1]).computerize).last
  end
end

class Adv5_b < TestFramework
  def logic(t)
    IntComputator.new(t.split(',').map(&:to_i), [5]).computerize.first
  end
end

adva = Adv5_a.new({
                      '1002,4,3,4,33' => nil
                  }, 5)
#adva.test
puts adva.run

advb = Adv5_b.new({
                      '3,9,8,9,10,9,4,9,99,-1,8' => nil,
                      '3,9,7,9,10,9,4,9,99,-1,8' => nil,
                      '3,3,1108,-1,8,3,4,3,99' => nil,
                      '3,3,1107,-1,8,3,4,3,99' => nil,
                      '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9' => nil,
                      '3,3,1105,-1,9,1101,0,0,12,4,12,99,1' => nil,
                      '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99' => nil
                  }, 5)
#advb.test
puts advb.run
