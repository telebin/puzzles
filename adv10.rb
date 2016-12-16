require './test_framework'

class Bot
  def initialize bots
    @bots = bots
    @chips = []
  end

  def lo
    @chips.shift
  end
  def hi
    @chips.pop
  end
  def take chip
    @chips.push(chip).sort!
    if @chips.count > 1
  end
  def instruct instr
    @instr = instr
  end
end

class Adv10 < TestFramework
  def logic(t)
    @bots = []
    case t
    when /value (\d+) goes to bot (\d+)/
      @bots[$2] = Bot.new
  end
end

$testcase = ['value 5 goes to bot 2','bot 2 gives low to bot 1 and high to bot 0','value 3 goes to bot 1',
  'bot 1 gives low to output 1 and high to bot 0',  'bot 0 gives low to output 2 and high to output 0','value 2 goes to bot 2'
]
testa = Adv10.new({$testcase => 2})
testa.test
