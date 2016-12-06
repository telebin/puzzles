require 'thread'
$mut2 = Mutex.new
def bench count = 5000000, threads = 4
 p start = Time.now.to_f
 p thrcnt = count / 4
 thrs = []
 threads.times do |t|
   thrs << Thread.new { 
      (thrcnt*t..thrcnt*t+thrcnt).each do |i|
      Digest::MD5.hexdigest i.to_s
      if i % 5000 == 0 then
        $mut2.synchronize {
          puts i / 5000
        }
      end
     end
   }
 end
 thrs.each { |t| t.join }
 puts 'time: ' + (Time.now.to_f - start).to_s
end
