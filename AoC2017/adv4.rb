require '../test_framework'

class Adv4_a < TestFramework
  def logic(t)
    t.split("\n").map { |line| line.split.uniq == line.split }
  end
end

class Adv4_b < TestFramework
  def logic(t)
    t.split("\n").map do |line|
      sorted_tokens = line.split.map { |tok| tok.split('').sort.join }
      sorted_tokens == sorted_tokens.uniq
    end
  end
end

adva = Adv4_a.new({
                      'aa bb cc dd ee' => [true],
                      'aa bb cc dd aa' => [false],
                      'aa bb cc dd aaa' => [true]
                  }, 4)
# adva.test
# p adva.run.partition {|tf| tf}.map {|tf| tf.size}

advb = Adv4_b.new({
                      'abcde fghij' => [true],
                      'abcde xyz ecdab' => [false],
                      'a ab abc abd abf abj' => [true],
                      'iiii oiii ooii oooi oooo' => [true],
                      'oiii ioii iioi iiio' => [false]
                  }, 4)
advb.test
p advb.run.partition { |tf| tf }.map { |tf| tf.size }
