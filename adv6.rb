require './test_framework'

class Adv6_a < TestFramework
  def logic t
    t.split.map {|s| s.split ''}.transpose.map {|e| e.group_by {|i| i}.reduce {|pr, ne| pr[1].size > ne[1].size ? pr : ne}}.map {|e| e[0]}.join
  end
end

class Adv6_b < TestFramework
  def logic t
    t.split.map {|s| s.split ''}.transpose.map {|e| e.group_by {|i| i}.reduce {|pr, ne| pr[1].size < ne[1].size ? pr : ne}}.map {|e| e[0]}.join
  end
end

tests = Adv6_a.new({"eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar" => 'easter'})
testsb = Adv6_b.new({"eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar" => 'advent'})
# tests.test
testsb.test
File.open('AoC2016_inputs/day6.txt') { |f| 
  puts tests.logic f.readlines.join "\n"
}
File.open('AoC2016_inputs/day6.txt') { |f| 
  puts testsb.logic f.readlines.join "\n"
}