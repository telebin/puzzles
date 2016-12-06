require 'digest'
require 'thread'
def md5 msg
  Digest::MD5.hexdigest msg
end

def findHash inp, idx
  while idx += 1
    puts idx
    sum = md5( inp + idx.to_s )
    return sum[5], idx if sum[0...5] == '00000'
  end
end
def adv5_a inp
  pass = ''
  idx = -1
  puts "progress:\n--------"
  while pass.length < 8
    pc, idx = findHash( inp, idx )
    pass << pc
    puts pass + '-' * (8-pass.length)
  end
  pass
end

def findHash2 inp, idx, incr = 1
  begin
    sum = md5( inp + idx.to_s )
    return sum[5,2], idx if sum[0...5] == '00000' and (('0'..'7').include? sum[5])
  end while idx += incr
end
$mutex = Mutex.new
def adv5_b inp, idx = 0, incr = 1
  while $pass.include? '-'
    pc, idx = findHash2( inp, idx, incr )
    pi = pc[0].to_i
    $mutex.synchronize {
      $pass[pi] = pc[1] if $pass[pi] == '-'
    }
    puts pc + " :: " + $pass + ' :: ' + idx.to_s
    idx += incr
  end
  $pass
end

def multicalc inp, threads = 4
  start = Time.now.to_f
  $pass = '-' * 8
  puts "progress:"
  thrs = []
  threads.times do |t|
    thrs << Thread.new {
      adv5_b inp, t, threads
    }
  end
  thrs.each { |t| t.join }
  puts 'done in ' + (Time.now.to_f - start).to_s
  $pass
end
