require '../test_framework'

class Adv21Base < TestFramework
  def scramble(t)
    t.each do |instr|
      # puts "doing: #{instr}"
      case instr
        when /swap position (\d+) with position (\d+)/
          swap_pos $1.to_i, $2.to_i
        when /swap letter (\w) with letter (\w)/
          swap_letter $1, $2
        when /rotate (left|right) (\d+) steps?/
          rot ($1 == 'left' ? $2.to_i : -$2.to_i)
        when /rotate based on position of letter (\w)/
          rot_on $1
        when /reverse positions (\d+) through (\d+)/
          rev_pos $1.to_i, $2.to_i
        when /move position (\d+) to position (\d+)/
          move $1.to_i, $2.to_i
        else
          raise "error: Unknown code"
      end
      # puts "effect: #{@to_modif.join}"
    end
    # puts "scrambled #{@to_modif.join}"
    @to_modif.join
  end

  def swap_pos pos, with
    tmp = @to_modif[pos]
    @to_modif[pos] = @to_modif[with]
    @to_modif[with] = tmp
  end
  def swap_letter letter, with
    letter_pos = @to_modif.find_index letter
    @to_modif[@to_modif.find_index(with)] = letter
    @to_modif[letter_pos] = with
  end
  def rot by
    @to_modif.rotate! by
  end
  def rot_on letter
    char_pos = @to_modif.find_index(letter)
    rot -(char_pos + (char_pos >= 4 ? 2 : 1))
  end
  def rev_pos from, to
    @to_modif[from..to] = @to_modif[from..to].reverse
  end
  def move pos, to
    @to_modif.insert to, @to_modif.delete_at(pos)
  end
end

class Adv21_a < Adv21Base
  def logic(t)
    @to_modif = $string.chars
    scramble t
  end
end

class Adv21_b < Adv21Base
  def logic(t)
    $string.chars.permutation do |perm|
      @to_modif = perm.clone
      # printf "checking #{perm.join} - "
      break perm.join if scramble(t) == $string
    end
  end
end

scrambling_technique = ['swap position 4 with position 0', 'swap letter d with letter b', 'reverse positions 0 through 4',
  'rotate left 1 step', 'move position 1 to position 4', 'move position 3 to position 0', 'rotate based on position of letter b',
  'rotate based on position of letter d']

testa = Adv21_a.new({scrambling_technique => 'decab'}, 21)
$string = 'abcde'
testa.test
$string = 'abcdefgh'
puts testa.run

testb = Adv21_b.new({}, 21)
$string = 'dgfaehcb'
puts testb.run
$string = 'fbgdceah'
puts testb.run
