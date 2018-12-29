require 'singleton'
require '../test_framework'

def log(msg)
  # STDERR.puts msg.to_s
  # puts msg.to_s
end

class Point
  def initialize(coords)
    raise 'invalid point init' unless coords.is_a?(Array) && coords.count == 2
    @coords = coords
  end

  def x
    @coords.last
  end

  def y
    @coords.first
  end

  def move(by)
    Point.new [@coords.first + by.first, @coords.last + by.last]
  end

  def to_a
    @coords
  end

  def to_s
    "[y=#{y},x=#{x}]"
  end
end

class Wall
  include Singleton

  def empty?
    false
  end

  def taken_by?(_)
    false
  end

  def to_s
    '#'
  end
end

class Cavern
  attr_accessor :content

  def initialize(content = nil)
    @content = content
  end

  def empty?
    @content.nil?
  end

  def taken_by?(type)
    @content.class == type
  end

  def to_s
    @content ? @content.to_s : '.'
  end
end

class Unit
  def initialize
    @hp = 200
    @power = 3
  end

  def hp
    @hp
  end

  def hit
    @hp -= 3
  end

  def dead?
    @hp <= 0
  end
end

class Goblin < Unit
  def enemy_type
    Elf
  end

  def to_s
    'G'
  end
end

class Elf < Unit
  def enemy_type
    Goblin
  end

  def to_s
    'E'
  end
end

class GameMap
  # noinspection RubyStringKeysInHashInspection
  CONVERSIONS = {
      '#' => Proc.new { Wall.instance },
      '.' => Proc.new { Cavern.new },
      'G' => Proc.new { Cavern.new(Goblin.new) },
      'E' => Proc.new { Cavern.new(Elf.new) }
  }
  MOVES = [[-1, 0], [0, -1], [0, 1], [1, 0]]

  def initialize(textual_map)
    @map = textual_map.lines.reduce([]) do |arr, line|
      arr << line.chomp.chars.map { |char| CONVERSIONS[char].call }
    end
  end

  def generate_distance_map_for(point)
    @dists = Array.new(@map.size) { Array.new(@map[0].size) }
    p = point
    @dists[p.y][p.x] = 0
    to_visit = [p]
    until to_visit.empty?
      p = to_visit.shift
      MOVES.map { |m| p.move m }.each do |m|
        if @dists[m.y][m.x].nil? ? @map[m.y][m.x].empty? : @dists[m.y][m.x] > @dists[p.y][p.x] + 1
          @dists[m.y][m.x] = @dists[p.y][p.x] + 1
          to_visit.push m
        end
      end
    end
  end

  def find_all(type)
    points = []
    @map.each_with_index do |row, y|
      row.each_with_index do |field, x|
        if field.taken_by? type
          p = Point.new [y, x]
          points += MOVES.map { |m| p.move m }.select { |c| @map[c.y][c.x].empty? }
        end
      end
    end
    points
  end

  def find_closest(of_all)
    distances = of_all.map { |p| [@dists[p.y][p.x], p] }.reject { |d, _| d.nil? }
    min_dist = distances.map(&:first).min
    min = distances.select { |d, _| d == min_dist }.map(&:last).map(&:to_a).min
    min ? Point.new(min) : false
  end

  def in_range(point)
    what_current_attacks = enemy_for point
    to_attack = MOVES.map { |m| point.move m }.map do |p|
      @map[p.y][p.x].taken_by?(what_current_attacks) ? [p, @map[p.y][p.x].content] : nil
    end.reject(&:nil?).min_by { |p, u| u.hp }
    to_attack ? to_attack.first : false
  end

  def shortest_path_step(point)
    move_dists = MOVES.map { |m| point.move m }.map { |p| [p, @dists[p.y][p.x]] }.reject { |_, d| d.nil? }
    min_dist = move_dists.map(&:last).min
    move_dists.select { |_, d| d == min_dist }.first.first
  end

  def find_all_units
    points = []
    @map.each_with_index do |row, y|
      row.each_with_index do |field, x|
        points << Point.new([y, x]) if field.is_a?(Cavern) && !field.empty?
      end
    end
    points
  end

  def get_total_hp
    find_all_units.map { |u| @map[u.y][u.x].content.hp }.sum
  end

  def enemy_for(point)
    @map[point.y][point.x].content.enemy_type
  end

  def do_turn
    changed = false
    find_all_units.each do |unit|
      log "unit #{unit}"
      next if @map[unit.y][unit.x].empty?
      range = in_range unit
      log "in_range #{range}"
      if range
        changed = true
        enemy = @map[range.y][range.x].content
        log "enemy #{enemy.inspect}"
        enemy.hit
        log "enemy after hit #{enemy.inspect}"
        @map[range.y][range.x].content = nil if enemy.dead?
        log "niled dead enemy @ #{range}" if enemy.dead?
      else
        generate_distance_map_for unit
        closest = find_closest find_all(enemy_for unit)
        log "closest #{closest}"
        next unless closest
        generate_distance_map_for closest
        next_step = shortest_path_step unit
        log "next_step #{next_step}"
        changed = true
        @map[next_step.y][next_step.x].content = @map[unit.y][unit.x].content
        @map[unit.y][unit.x].content = nil
        log "moved: #{@map[next_step.y][next_step.x]} <- #{@map[unit.y][unit.x]}"
        range = in_range next_step
        log "in_range 2 #{range}"
        if range
          enemy = @map[range.y][range.x].content
          log "enemy #{enemy.inspect}"
          enemy.hit
          log "enemy after hit #{enemy.inspect}"
          @map[range.y][range.x].content = nil if enemy.dead?
          log "niled dead enemy @ #{range}" if enemy.dead?
        end
      end
    end
    changed
  end

  def to_s
    @map.map { |row| row.map(&:to_s).join }.join "\n"
  end
end

class Adv_a < TestFramework
  def logic(t)
    game_map = GameMap.new t
    turn = -2
    begin
      # STDERR.puts '---- next turn ---------------'
      turn += 1
      changed = game_map.do_turn
      # STDERR.puts game_map
    end while changed
    # STDERR.puts '---- end game  ---------------'
    turn * game_map.get_total_hp
  end
end

class Adv_b < TestFramework
  def logic(t)

  end
end

adva = Adv_a.new({
                     "#######\n#G..#E#\n#E#E.E#\n#G.##.#\n#...#E#\n#...E.#\n#######\n" => 36334,
                     "#######\n#E..EG#\n#.#G.E#\n#E.##E#\n#G..#.#\n#..E#.#\n#######\n" => 39514,
                     "#######\n#E.G#.#\n#.#G..#\n#G.#.G#\n#G..#.#\n#...E.#\n#######\n" => 27755,
                     "#######\n#.E...#\n#.#..G#\n#.###.#\n#E#G#G#\n#...#G#\n#######\n" => 28944,
                     "#########\n#G......#\n#.E.#...#\n#..##..G#\n#...##..#\n#...#...#\n#.G...G.#\n#.....G.#\n#########" => 18740
                 }, 15)
# adva.test
puts adva.run

advb = Adv_b.new({},)
# advb.test
# puts advb.run
