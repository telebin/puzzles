require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class Adv13Base < TestFramework
  def map_layers(input)
    input.split("\n").reduce([]) { |a, l| /(\d+): (\d+)/ =~ l; a[$1.to_i] = { range: $2.to_i, pos: 0, dir: 1 }; a }
  end

  def get_where_caught(layers)
    caught_on = []
    layers.count.times do |layer_num|
      caught_on << layer_num if layers[layer_num] && layers[layer_num][:pos] == 0
      move_sentinels(layers)
    end
    caught_on
  end

    def move_sentinels(layers)
      layers.each do |layer|
        next unless layer
        next_pos = layer[:pos] + layer[:dir]
        layer[:dir] = -layer[:dir] if next_pos >= layer[:range] || next_pos < 0
        layer[:pos] = layer[:pos] + layer[:dir]
      end
    end
end

class Adv13_a < Adv13Base
  def logic(t)
    layers = map_layers t
    get_where_caught(layers).reduce { |acc, l_num| acc + layers[l_num][:range] * l_num }
  end

end

class Adv13_b < Adv13Base
  def logic(t)
    layers = map_layers t
    counter = 0
    while did_get_caught(deep_copy layers)
      move_sentinels layers
      counter += 1
      log "counter is now #{counter}" if counter % 1000 == 0
    end
    counter
  end

  def did_get_caught(layers)
    layers.count.times do |layer_num|
      return true if layers[layer_num] && layers[layer_num][:pos] == 0
      move_sentinels(layers)
    end
    false
  end

  private
    def deep_copy(layers)
      layers.reduce([]) { |a, h| a << h.clone; a }
    end
end

adva = Adv13_a.new({ "0: 3\n1: 2\n4: 4\n6: 4\n" => 24 }, 13)
adva.test
# puts adva.run

advb = Adv13_b.new({ "0: 3\n1: 2\n4: 4\n6: 4\n" => 10 }, 13)
advb.test
puts advb.run
