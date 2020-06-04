require '../test_framework'
require_relative 'int_computator'

class Adv22_a < TestFramework
  def logic(t)
    deck = ($test ? 0..9 : 0...10007).to_a
    t.split("\n").each do |instr|
      case instr
      when /cut (-?\d+)/
        deck = deck[$1.to_i..] + deck[0...$1.to_i]
      when /deal with increment (\d+)/
        new_deck = Array.new(deck.size)
        (0...deck.size).map { |i| i * $1.to_i % deck.size }.each { |i| new_deck[i] = deck.shift }
        deck = new_deck
      else
        deck.reverse!
      end
    end
    $test ? deck : deck.find_index(2019)
  end
end

class Adv22_b < TestFramework
  def logic(t)
  end
end

$logging = true
adva = Adv22_a.new({
                       "deal with increment 7\ndeal into new stack\ndeal into new stack" => [0, 3, 6, 9, 2, 5, 8, 1, 4, 7],
                       "cut 6\ndeal with increment 7\ndeal into new stack" => [3, 0, 7, 4, 1, 8, 5, 2, 9, 6],
                       "deal with increment 7\ndeal with increment 9\ncut -2" => [6, 3, 0, 7, 4, 1, 8, 5, 2, 9],
                       "deal into new stack\ncut -2\ndeal with increment 7\ncut 8\ncut -4\ndeal with increment 7\ncut 3\ndeal with increment 9\ndeal with increment 3\ncut -1" => [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]
                   }, 22)
#adva.test
p adva.run

advb = Adv22_b.new({
                   }, 22)
#p advb.run
