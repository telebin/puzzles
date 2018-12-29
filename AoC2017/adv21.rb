require '../test_framework'

def log(msg)
  STDERR.puts msg
end

class Adv21_a < TestFramework
  def logic(t)
    grid = ".#.\n..#\n###".split("\n").map(&:chars) #.map { |chars| chars.map { |c| c == '#' } }
    @matrices = t.split("\n").map do |l|
      /([^\s]+) => (.+)/ =~ l
      keys = prepare_keys $1
      value = $2.split('/').map(&:chars)
      keys.map { |k| { k => value } }
    end.flatten.reduce({}) { |a, h| a.merge h }
    5.times do |i|
      grid = divide(grid)
      log "after #{i} mapping:\n#{grid.map(&:inspect).join("\n")}"
    end
    grid.flatten.count '#'
  end

  def prepare_keys(pattern)
    arrayed = pattern.split('/').map(&:chars) #.map { |chars| chars.map { |c| c == '#' } }
    fliph = arrayed.map { |a| a.reverse }
    flipv = arrayed.reverse
    fliphv = fliph.reverse
    trans = arrayed.transpose
    tfliph = trans.map { |a| a.reverse }
    tflipv = trans.reverse
    tfliphv = tfliph.reverse
    # log [arrayed, fliph, flipv, fliphv, trans, tfliph, tflipv, tfliphv].map { |m| m.map(&:inspect).join("\n") }.join("\n\n")
    [arrayed, fliph, flipv, fliphv, trans, tfliph, tflipv, tfliphv]
  end

  private
  def divide(grid)
    grid_size = grid.size
    divisor = 2 + grid_size % 2
    new_grid_size = grid_size / divisor * (divisor + 1)
    new_grid = Array.new(new_grid_size) { Array.new }
    divided = []
    log "dividing #{grid.inspect} by divisor #{divisor}"
    if grid_size % 2 == 0
      (0...grid_size).step(divisor) do |i|
        (0...grid_size).step(divisor) do |j|
          # log [i, j].inspect
          # log 'dividing to ' + [[grid[i][j], grid[i][j + 1]], [grid[i + 1][j], grid[i + 1][j + 1]]].inspect
          divided << [[grid[i][j], grid[i][j + 1]], [grid[i + 1][j], grid[i + 1][j + 1]]]
        end
      end
    elsif grid_size % 3 == 0
      (0...grid_size).step(divisor) do |i|
        (0...grid_size).step(divisor) do |j|
          # log [i, j].inspect
          log 'dividing: ' + [[grid[i + 0][j], grid[i + 0][j + 1], grid[i + 0][j + 2]],
                              [grid[i + 1][j], grid[i + 1][j + 1], grid[i + 1][j + 2]],
                              [grid[i + 2][j], grid[i + 2][j + 1], grid[i + 2][j + 2]]].inspect
          divided << [[grid[i + 0][j], grid[i + 0][j + 1], grid[i + 0][j + 2]],
                      [grid[i + 1][j], grid[i + 1][j + 1], grid[i + 1][j + 2]],
                      [grid[i + 2][j], grid[i + 2][j + 1], grid[i + 2][j + 2]]]
        end
      end
    end
    log "divided: #{divided}"
    divided.map! { |g|
      # log "searching #{g} in #{@matrices}"
      @matrices[g] || (puts "#{g.inspect} not found")}
    log "after mapping: #{divided}"

    small_counter = 0
    (0...new_grid_size).step(divisor + 1) do |i|
      log "new big step #{i}"
      (grid_size / divisor).steps do |j|
        log "new small step #{j}"
        (divisor + 1).times { |k|
          log 'new_grid: ' + new_grid.inspect
          divr = divided[small_counter+j]
          log divr.to_a.compact.empty?
          new_grid[i + k] += divr[k]
          log "adding divided[#{small_counter} + #{j}][#{k}] (#{divr[k]}) to new grid at [#{i} + #{k}]\n =>#{new_grid.inspect}"
        }
      end
      small_counter += divisor
    end
    new_grid
  end

end

class Adv21_b < TestFramework
  def logic(t)

  end
end

adva = Adv21_a.new({ '../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#' => 12 }, 21)
# adva.test
puts adva.run

advb = Adv21_b.new({}, 21)
# advb.test
# puts advb.run
