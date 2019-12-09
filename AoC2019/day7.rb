require '../test_framework'
require_relative 'int_computator'

class Adv7_a < TestFramework
  def logic(t)
    program = t.split(',').map(&:to_i)
    (0..4).to_a.permutation.map do |phases|
      amp_a = IntComputator.new(program.clone, [phases[0], 0])
      amp_b = IntComputator.new(program.clone, [phases[1]] + amp_a.computerize)
      amp_c = IntComputator.new(program.clone, [phases[2]] + amp_b.computerize)
      amp_d = IntComputator.new(program.clone, [phases[3]] + amp_c.computerize)
      amp_e = IntComputator.new(program.clone, [phases[4]] + amp_d.computerize)
      amp_e.computerize.first
    end.max
  end
end

class Adv7_b < TestFramework
  def logic(t)
    program = t.split(',').map(&:to_i)
    (5..9).to_a.permutation.map do |phases|
      amp_a = IntComputator.new(program.clone, [phases[0]])
      amp_b = IntComputator.new(program.clone, [phases[1]])
      amp_c = IntComputator.new(program.clone, [phases[2]])
      amp_d = IntComputator.new(program.clone, [phases[3]])
      amp_e = IntComputator.new(program.clone, [phases[4]])
      res_e = 0
      begin
        res_a = amp_a.computerize(res_e).first
        res_b = amp_b.computerize(res_a).first
        res_c = amp_c.computerize(res_b).first
        res_d = amp_d.computerize(res_c).first
        res_e = amp_e.computerize(res_d).first || res_e
      end until amp_a.state == :HALT
      res_e
    end.max
  end
end

#$logging = true
adva = Adv7_a.new({
                      '3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0' => 43210,
                      '3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0' => 54321,
                      '3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0' => 65210
                  }, 7)
adva.test
puts adva.run

advb = Adv7_b.new({
                      '3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5' => 139629729,
                      '3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10' => 18216
                  }, 7)
advb.test
puts advb.run
