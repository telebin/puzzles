def adv1_a s
 d = [0,0,0,0]
 dir = 1
 s.split(/\W+/).each { |step|
  dir = (dir + (step[0] == 'R' ? 1 : -1)) % 4
  d[dir] += step[1..(step.length)].to_i
 }
 [d[0], d[2]].max - [d[0], d[2]].min + [d[1], d[3]].max - [d[1], d[3]].min
end
