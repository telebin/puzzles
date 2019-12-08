require '../test_framework'
require_relative 'int_computator'

class Adv_a < TestFramework
  def logic(t)
    tape = t.split(',').map(&:to_i)
    unless $test
      tape[1] = 12
      tape[2] = 2
    end
    IntComputator.new(tape).computerize.first
    tape.first
  end
end

class Adv_b < TestFramework
  def logic(t)
    counter = 0
    begin
      tape = t.split(',').map(&:to_i)
      tape[1] = counter / 100
      tape[2] = counter % 100
      IntComputator.new(tape).computerize
      counter += 1
    end until tape.first == 19690720

    tape[0..2]
  end
end

adva = Adv_a.new({
                     '1,9,10,3,2,3,11,0,99,30,40,50' => 3500,
                     '1,0,0,0,99' => 2,
                     '2,3,0,3,99' => 2,
                     '2,4,4,5,99,0' => 2,
                     '1,1,1,4,99,5,6,0,99' => 30
                 }, 2)
#adva.test
$logging = false
puts adva.run

p Adv_b.new({}, 2).run
