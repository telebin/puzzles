require './test_framework'

class Adv6_a < TestFramework
  def logic t
    t.map {|s| s.chars }.transpose.map {|e| e.group_by {|i| i}.reduce {|pr, ne| pr[1].size > ne[1].size ? pr : ne}}.map {|e| e[0]}.join
  end
end

class Adv6_b < TestFramework
  def logic t
    t.map {|s| s.chars }.transpose.map {|e| e.group_by {|i| i}.reduce {|pr, ne| pr[1].size < ne[1].size ? pr : ne}}.map {|e| e[0]}.join
  end
end

tests = Adv6_a.new({"eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar".split => 'easter'}, 6)
testsb = Adv6_b.new({"eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar".split => 'advent'}, 6)
tests.test
testsb.test
puts tests.run
puts testsb.run
