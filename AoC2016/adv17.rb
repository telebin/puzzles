require '../test_framework'
require '../dijkstra'
require 'digest'

def md5f4(msg)
  Digest::MD5.hexdigest(msg)[0, 4].chars
end

class Adv17Base < TestFramework
  def go(path, posx, posy)
    if posx == 3 and posy == 3
      @shortest = path if !@shortest or path.size < @shortest.size
      @longest = path if !@longest or path.size > @longest.size
      return
    end
    u, d, l, r = md5f4(@passcode + path)
    go(path+'D', posx, posy + 1) if posy < 3 and open? d
    go(path+'R', posx + 1, posy) if posx < 3 and open? r
    go(path+'U', posx, posy - 1) if posy > 0 and open? u
    go(path+'L', posx - 1, posy) if posx > 0 and open? l
  end

  def open?(v)
    v.to_i(16) > 0xA
  end
end

class Adv17_a < Adv17Base
  def logic(t)
    @passcode = t
    @longest = nil
    @shortest = nil
    go('', 0, 0)
    @shortest
  end
end

class Adv17_b < Adv17Base
  def logic(t)
    @passcode = t
    @longest = nil
    @shortest = nil
    go('', 0, 0)
    @longest.length
  end
end

testa = Adv17_a.new({'ihgpwlah' => 'DDRRRD', 'kglvqrro' => 'DDUDRLRRUDRD', 'ulqzkmiv' => 'DRURDRUDDLLDLUURRDULRLDUUDDDRR'})
testa.test
puts testa.run 'edjrjqaa'

testb = Adv17_b.new({'ihgpwlah' => 370, 'kglvqrro' => 492, 'ulqzkmiv' => 830})
testb.test
puts testb.run 'edjrjqaa'
