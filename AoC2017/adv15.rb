require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Generator
  attr_writer :factor, :criteria

  def initialize(start_val)
    @current = start_val
  end

  def next
    begin
      @current = @current * @factor % 2147483647
    end until @current % @criteria == 0
    @current
  end
end

class Adv15_a < TestFramework
  def logic(t)
    gen_a, gen_b = t.split("\n").map { |l| Generator.new l.match(/\d+$/)[0].to_i }
    gen_a.factor = 16807
    gen_b.factor = 48271
    4e7.to_i.times.reduce(0) { |a, _| gen_a.next & 0xFFFF == gen_b.next & 0xFFFF ? a + 1 : a }
  end
end

class Adv15_b < TestFramework
  def logic(t)
    gen_a, gen_b = t.split("\n").map { |l| Generator.new l.match(/\d+$/)[0].to_i }
    gen_a.factor = 16807
    gen_b.factor = 48271
    gen_a.criteria = 4
    gen_b.criteria = 8
    5e6.to_i.times.reduce(0) { |a, _|
      gen_a.next & 0xFFFF == gen_b.next & 0xFFFF ? a + 1 : a }
  end
end

adva = Adv15_a.new({ "Generator A starts with 65\nGenerator B starts with 8921" => 588 }, 15)
# adva.test
# puts adva.run

advb = Adv15_b.new({ "Generator A starts with 65\nGenerator B starts with 8921" => 309 }, 15)
# advb.test
puts advb.run
