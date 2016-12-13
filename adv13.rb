class Adv13
  def draw(t)
    printf '   '
    35.times {|t| printf (t % 10).to_s}
    puts
    40.times do |y|
      printf '%2d ', y
      35.times do |x|
        printf (x*x + 3*x + 2*x*y + y + y*y + t).to_s(2).chars.map {|e| e.to_i}.reduce {|m,c| m+c} % 2 == 0 ? ' ' : '#'
      end
      puts ' ' + y.to_s
    end
    printf '   '
    35.times {|t| printf (t % 10).to_s}
    puts
  end
end

Adv13.new.draw 1362
