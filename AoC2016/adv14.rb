require '../test_framework'
require 'digest'
require 'thread'
STDOUT.sync = true

def md5 msg
  Digest::MD5.hexdigest(msg).downcase
end

class SumManager
  def initialize salt, hashings = 0
    @mds = [[],[],[],[]]
    thrs = []
    4.times do |t|
      thrs << Thread.new {
        (8000*t...8000*(t+1)).each do |i|
          md = md5("#{salt}#{i}")
          hashings.times { md = md5 md }
          @mds[t] << md
        end
      }
    end
    thrs.each { |t| t.join }
    @mds = @mds.flatten
    @index = -1
  end

  def next
    @mds[@mi+=1]
  end

  def advance
    @mi = (@index += 1)
    @mds[@index]
  end

  def current_index
    @index
  end
end

class Adv14_a < TestFramework
  def logic(t)
    puts 'Generating hashes...'
    sm = SumManager.new t
    puts 'Searching...'
    64.times do
      while /(\w)\1{2}/ =~ sm.advance
      end
      c = $1
      redo if 1000.times do |i|
        break i if Regexp.new("#{c}{5}") =~ sm.next
      end == 1000
    end
    puts "result: #{sm.current_index}"
    sm.current_index
  end
end

class Adv14_b < TestFramework
  def logic(t)
    puts 'Generating hashes...'
    sm = SumManager.new t, 2016
    puts 'Searching...'
    64.times do
      until /(\w)\1{2}/ =~ sm.advance
      end
      c = $1
      redo if 1000.times do |i|
        break i if Regexp.new("#{c}{5}") =~ sm.next
      end == 1000
    end
    printf 'result: '
    p sm.current_index
  end
end


testa = Adv14_a.new({'abc' => 22728})
# testa.test
# puts testa.logic 'jlmsuwbz'

testb = Adv14_b.new({'abc' => 22551})
# testb.test
# puts testb.logic 'jlmsuwbz'
