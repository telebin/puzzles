require '../test_framework'
require_relative 'int_computator'

class Adv9_a < TestFramework
  def logic(t)
    program = t.split(',').map(&:to_i)
    IntComputator.new(program, [1]).computerize.join ','
  end
end

class Adv9_b < TestFramework
  def logic(t)
    program = t.split(',').map(&:to_i)
    IntComputator.new(program, [2]).computerize.join ','
  end
end

#$logging = true
adva = Adv9_a.new({
                      '109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99' => '109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99',
                      '1102,34915192,34915192,7,4,7,99,0' => '1219070632396864',
                      '104,1125899906842624,99' => '1125899906842624'
                  }, 9)
#adva.test
#puts adva.run

advb = Adv9_b.new({
                  }, 9)
puts advb.run
