require '../test_framework'

# returns:
#  1 if other is HIGHER than self
# -1 if other is LOWER than self
#  2 if other contains self
# -2 if other is contained by self
class Range
  def fits? other
    # p "comparing #{self} and #{other}"
    return 2 if self.begin >= other.begin and self.last <= other.last
    return -2 if self.begin <= other.begin and self.last >= other.last
    return 1 if self.include? (other.begin-1) and not self.include? other.last
    return -1 if self.include? (other.last+1) and not self.include? other.begin
    0
  end
end

class Adv20Base < TestFramework
  def get_ranges t
    ranges = t.map {|range| r = range.split('-'); (r[0].to_i..r[1].to_i) }.sort_by {|r| r.begin}
    @combined = []
    ranges.each do |range|
      index = @combined.find_index {|c| range.fits? c}
      # p "found index: #{index}"
      if index
        case range.fits? @combined[index]
          when 0
            # p "0: comb << #{range}"
            @combined << range
          when -2
            # p "-2: #{range}"
            @combined[index] = range
          when 1
            # p "1: (#{range.begin}..#{@combined[index].last})"
            @combined[index] = (range.begin..(@combined[index].last))
          when -1
            # p "-1: (#{@combined[index].begin}..#{range.last})"
            @combined[index] = (@combined[index].begin..(range.last))
          else
            # p "else: #{range.fits? @combined[index]}, next"
            next
        end
      else
        # p "after case: #{range}"
        @combined << range
      end
      recombine
    end
    @combined
  end
  
  def recombine
    @combined = @combined.sort_by {|c| c.begin}
    if @combined.each_cons(2) { |l,r| break true if (l.fits? r) != 0 }
      # puts 'recombining ' + @combined.to_s
      new_comb = []
      @combined.each do |combined|
        index = new_comb.find_index {|c| combined.fits? c}
        if index
          case index
            when 0
              new_comb << combined
            when -2
              new_comb[index] = combined
            when -1
              new_comb[index] << (combined.begin..(new_comb[index].last))
            when 1
              new_comb[index] << (new_comb[index].begin..(combined.last))
          end
        else
          new_comb << combined
        end
      end
      @combined = new_comb
      # puts 'recombined ' + @combined.to_s
    else
      puts 'no need to recombine ' + @combined.to_s
    end
  end
end

class Adv20AltBase < TestFramework
  def get_ranges t
    raw_values = t.map { |range|
      l,r = range.split('-'); [{v: l.to_i, from: true},{v: r.to_i, from: false}]
    }.flatten.sort_by { |r| r[:v] }
    p raw_values
    ranges = []
    open_range = nil
    closed_range = nil
    raw_values.each do |r|
      if r[:from]
        if open_range
          if closed_range
            unless closed_range + 1 >= r[:v]
              p "1: (#{open_range}..#{closed_range})"
              ranges << (open_range..closed_range)
              open_range = r[:v]
            end
            closed_range = nil
          end
        else
          open_range = r[:v]
        end
      else
        closed_range = r[:v]
      end
    end
    ranges
  end
end

class Adv20_a < Adv20AltBase
  def logic(t)
    get_ranges(t).first.last + 1
  end
end

class Adv20_b < Adv20AltBase
  def logic(t)
    ranges = get_ranges t
    allowed = 0
    ranges.each_cons(2) do |l,r|
      puts "range (#{l.last}..#{r.begin}), allowed: #{r.begin - (l.last + 1)}"
      allowed += r.begin - (l.lats + 1)
    end
    allowed
  end

end

# testa = Adv20_a.new({['5-8','0-2','4-7'] => 3}, 20)
# testa.test
# puts testa.run

testb = Adv20_b.new({}, 20)
puts testb.run
