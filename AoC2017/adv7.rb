require '../test_framework'

class Program

  attr_accessor :parent, :weight, :children
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def total_weight
    @total_weight ||= @weight + children.map { |c| c.total_weight }.sum
  end

  def inspect
    "Program \"#{@name}\" (#{@weight}, total #{@total_weight})"
  end
end

class Adv7Base < TestFramework

  def parse_programs(text)
    @programs = {}
    text.split("\n").each do |line|
      /(?<name>\w+)\s\((?<weight>\d+)\)(?:\W+(?<children>.+))?$/ =~ line
      children = children.to_s.split(',').map(&:strip)
      # puts "found parent named #{name} weight #{weight} and children #{children}"
      parent_prog = @programs[name.to_sym] ||= Program.new(name)
      parent_prog.weight = weight.to_i
      parent_prog.children = children.map { |its_name| @programs[its_name.to_sym] ||= Program.new(its_name) }
      parent_prog.children.each { |cp| cp.parent = parent_prog }
    end
    @programs
  end

end

class Adv7_a < Adv7Base
  def logic(t)
    parse_programs(t).values.find { |prog| !prog.parent }.name
  end
end

class Adv7_b < Adv7Base
  def logic(t)
    parse_programs t
    grand_parent = parse_programs(t).values.find { |prog| !prog.parent }
    grand_parent.total_weight

    grouped_children = find_unbalanced(grand_parent).parent.children.group_by { |c| c.total_weight }.values
    unbalanced = grouped_children.find { |c| c.size == 1 }[0]
    balanced_weight = grouped_children.find { |c| c.size != 1 }[0].total_weight
    unbalanced.weight - (unbalanced.total_weight - balanced_weight)
  end

  def find_unbalanced(parent)
    children_weights = parent.children.group_by { |c| c.total_weight }.values
    if (unbalanced = children_weights.find { |c_arr| c_arr.size == 1 })
      find_unbalanced unbalanced[0]
    else
      parent
    end
  end
end

adva = Adv7_a.new({
                      "pbga (66)\nxhth (57)\nebii (61)\nhavc (66)\nktlj (57)\nfwft (72) -> ktlj, cntj, xhth\n" +
                          "qoyq (66)\npadx (45) -> pbga, havc, qoyq\ntknk (41) -> ugml, padx, fwft\njptl (61)\n" +
                          "ugml (68) -> gyxo, ebii, jptl\ngyxo (61)\ncntj (57)" => 'tknk'
                  }, 7)
# adva.test
# puts adva.run

advb = Adv7_b.new({
                      "pbga (66)\nxhth (57)\nebii (61)\nhavc (66)\nktlj (57)\nfwft (72) -> ktlj, cntj, xhth\n" +
                          "qoyq (66)\npadx (45) -> pbga, havc, qoyq\ntknk (41) -> ugml, padx, fwft\njptl (61)\n" +
                          "ugml (68) -> gyxo, ebii, jptl\ngyxo (61)\ncntj (57)" => 60
                  }, 7)
advb.test
puts advb.run
