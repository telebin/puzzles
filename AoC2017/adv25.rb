require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class TapeHash < Hash
  def initialize
    @pos = 0
  end

  def set_move(value, dir)
    self[@pos] = value
    @pos += dir
  end

  def get
    self[@pos] ||= 0
  end
end

class State
  attr_reader :pos, :neg

  def initialize(neg, pos)
    @neg = neg
    @pos = pos
  end
end

class StateAction
  attr_reader :dir, :write, :next_state

  def initialize(write, dir, next_state)
    @write = write
    @dir = dir
    @next_state = next_state
  end
end

class TuringMachine
  attr_reader :tape

  def initialize(states, begin_in, steps)
    @tape = TapeHash.new
    @states = states
    @state = begin_in
    @steps = steps
  end

  def start
    @steps.times do
      action = @tape.get == 0 ? @states[@state].neg : @states[@state].pos
      @tape.set_move action.write, action.dir
      @state = action.next_state
    end
    tape
  end
end

class Adv25_a < TestFramework
  def logic(t)
    input = StringIO.new t
    /^Begin in state (\w)\.$/ =~ input.readline
    begin_in = $1.to_sym
    /^Perform a diagnostic checksum after (\d+) steps\.$/ =~ input.readline
    steps = $1.to_i
    input.readline # empty line
    states = {}
    until input.eof?
      /^In state (\w):$/ =~ input.readline
      states[$1.to_sym] = parse_state input
    end
    log states.inspect
    tm = TuringMachine.new states, begin_in, steps
    tm.start.values.count(1)
  end

  private
  def parse_state(input)
    input.readline #/If the current value is 0:$/
    action_neg = parse_action(input)
    input.readline #/If the current value is 1:$/
    action_pos = parse_action(input)
    input.readline unless input.eof? # empty line
    State.new action_neg, action_pos
  end

  def parse_action(input)
    /- Write the value ([01])\.$/ =~ input.readline
    write = $1.to_i
    /- Move one slot to the (left|right)\.$/ =~ input.readline
    dir = $1 == 'left' ? -1 : 1
    /- Continue with state (\w)\.$/ =~ input.readline
    next_state = $1.to_sym
    StateAction.new write, dir, next_state
  end
end

class Adv25_b < TestFramework
  def logic(t)

  end
end

test_data = 'Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
'

adva = Adv25_a.new({ test_data => 3 }, 25)
# adva.test
puts adva.run

advb = Adv25_b.new({}, 25)
# advb.test
# puts advb.run
