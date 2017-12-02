require '../test_framework'
require '../dijkstra'
require 'digest'

def md5f4(msg)
  Digest::MD5.hexdigest(msg)[0, 4].chars
end

class Adv17 < TestFramework
  def logic(t)
    @passcode = t.clone
    @visited = []
    path = ''
    go(path, 0, 0)
  end

  def go(path, posx, posy)
    return path if posx == 3 and posy == 3
    return if @visited.include? path
    @visited << path
    u, d, l, r = md5f4(@passcode + path)
    go(path+'D', posx, posy + 1) if posy < 3 and open? d
    go(path+'R', posx + 1, posy) if posx < 3 and open? r
    go(path+'U', posx, posy - 1) if posy > 0 and open? u
    go(path+'L', posx - 1, posy) if posx > 0 and open? l
  end

  def open?(v)
    v.to_i(16) < 0xB
  end
end

testa = Adv17.new({'ihgpwlah' => 'DDRRRD', 'kglvqrro' => 'DDUDRLRRUDRD', 'ulqzkmiv' => 'DRURDRUDDLLDLUURRDULRLDUUDDDRR'})
testa.test
# puts testa.logic 'edjrjqaa'
