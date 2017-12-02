require '../test_framework'

class Adv7Base < TestFramework
  def subify t
    copyin = String.new t
    subs = []
    s = copyin.slice!(/\w+|(\[\w+\])/)
    while s
      subs << s
      s = copyin.slice!(/\w+|(\[\w+\])/)
    end
    subs.partition {|e| e[0] == '[' }
  end
end

class Adv7_a < Adv7Base
  def logic t
    subs = subify t
    subs[0].each do |sub|
      m = sub.match /(\w)(\w)\2\1/
      return false if m and !m[0].match /(\w)(\w)\1/
    end
    subs[1].each do |sub|
      m = sub.match /(\w)(\w)\2\1/
      return true if m and !m[0].match /(\w)(\w)\1/
    end
    false
  end
end

class Adv7_b < Adv7Base
  def logic t
    subs = subify t
    negs = []
    subs[0].each do |sub|
      while (m = sub.match /(\w)(\w)\1/)
        sub = sub.slice m.end(1)..-1
        if m[1] == m[2]
          next
        end
        negs << m[0]
      end
    end
    poss = []
    subs[1].each do |sub|
      while (m = sub.match /(\w)(\w)\1/)
        sub = sub.slice m.end(1)..-1
        if m[1] == m[2]
          next
        end
        poss << "#{m[2]}#{m[1]}#{m[2]}"
      end
    end
    (negs & poss).empty? ? false : true
  end
end

tests = Adv7_a.new({'abba[mnop]qrst' => true, 'abcd[bddb]xyyx' => false, 'aaaa[qwer]tyui' => false, 'ioxxoj[asdfgh]zxcvbn' => true})
testsb = Adv7_b.new({'aba[bab]xyz' => true, 'xyx[xyx]xyx' => false, 'aaa[kek]eke' => true, 'zazbz[bzb]cdb' => true})
testsb.test

File.open('inputs/day7.txt') { |f|
  $lines = f.readlines
}
counter = 0
$lines.each { |l|
  counter += 1 if tests.logic l
}
# puts counter
counter = 0
$lines.each { |l|
  counter += 1 if testsb.logic l
}
puts counter