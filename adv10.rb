require './test_framework'

TO_COMPARE = [17, 61]
$comparing_bot = 0

class Output
  def initialize
    @chips = []
  end

  def take(chip)
    @chips.push(chip)
  end

  def to_i
    @chips.last
  end
end
class Bot
  def initialize bot_no
    @bot_no = bot_no
    @chips = []
  end

  def take(chip)
    @chips.push(chip)
    if @chips.count > 1
      @chips.sort!
      puts "bot \##{$comparing_bot = @bot_no} has #{@chips}" if @chips == TO_COMPARE
      @instr[:lo].take @chips.shift
      @instr[:hi].take @chips.pop
    end
  end

  def instruct(instr)
    @instr = instr
  end
end

class Adv10 < TestFramework
  def logic(t)
    @collectors = {:bot => [], :output => []}
    instructions = t.partition { |e| e.start_with? 'bot' }
    instructions[0].each do |ins|
      m = ins.match /bot (\d+) gives low to (output|bot) (\d+) and high to (output|bot) (\d+)/
      bot = get_collector(:bot.to_s, m[1].to_i)
      lo_rec = get_collector(m[2], m[3].to_i)
      hi_rec = get_collector(m[4], m[5].to_i)
      bot.instruct({:lo => lo_rec, :hi => hi_rec})
    end
    instructions[1].each do |ins|
      m = ins.match /value (\d+) goes to bot (\d+)/
      get_collector(:bot.to_s, m[2].to_i).take m[1].to_i
    end
    outputs = @collectors[:output]
    puts outputs[0].to_i * outputs[1].to_i * outputs[2].to_i
    $comparing_bot
  end

  def get_collector(type, index)
    if type == 'output'
      outputs = @collectors[:output]
      outputs[index] = Output.new unless outputs[index]
      outputs[index]
    else
      bots = @collectors[:bot]
      bots[index] = Bot.new index unless bots[index]
      bots[index]
    end
  end
end

$testcase = ['value 5 goes to bot 2', 'bot 2 gives low to bot 1 and high to bot 0', 'value 3 goes to bot 1',
             'bot 1 gives low to output 1 and high to bot 0', 'bot 0 gives low to output 2 and high to output 0', 'value 2 goes to bot 2'
]
File.open('AoC2016_inputs/day10.txt') { |f| $lines = f.readlines }

testa = Adv10.new({$testcase => 2})
testa.test
puts testa.logic $lines