require '../test_framework'

def log(msg)
  STDERR.puts msg.to_s
end

class ReceivedError < StandardError

end

class Adv18_a < TestFramework
  def logic(t)
    @playing = nil
    @rcvd = nil
    @regs = {}
    @ip = 0
    @program = t.split("\n").map do |line|
      /([^\s]+)\s([^\s]+)(?:\s([^\s]+))?$/ =~ line
      { op: method($1.to_sym), op1: $2, op2: parse_operand($3) }
    end
    begin
      while @ip >= 0 && @ip < @program.length
        log "program op = #{@program[@ip][:op]}, #{@program[@ip][:op1]}, #{@program[@ip][:op2]}"
        @program[@ip][:op].call(@program[@ip][:op1], @program[@ip][:op2])
        @ip += 1
        log 'ip now: ' + @ip.to_s
      end
    rescue ReceivedError => _
      log "recovered #{@rcvd}"
    end
    @rcvd
  end

  def snd(op1, _)
    @playing = get_value_from op1
  end

  def set(op1, op2)
    @regs[op1] = get_value_from op2
  end

  def add(op1, op2)
    @regs[op1] = get_value_from(op1) + get_value_from(op2)
  end

  def mul(op1, op2)
    @regs[op1] = get_value_from(op1) * get_value_from(op2)
  end

  def mod(op1, op2)
    @regs[op1] = get_value_from(op1) % get_value_from(op2)
  end

  def rcv(op1, _)
    @rcvd = @playing if (@regs[op1] || 0) != 0
    raise ReceivedError if (@regs[op1] || 0) != 0
  end

  def jgz(op1, op2)
    @ip += op2.to_i - 1 if @regs[op1] > 0
  end

  def parse_operand(operand)
    ('a'..'z').include?(operand) ? operand : operand.to_i if operand
  end

  def get_value_from(operand)
    operand.is_a?(Numeric) ? operand : (@regs[operand] ||= 0)
  end
end

class Program
  attr_writer :partner
  attr_reader :sent, :blocked

  def initialize(pid, input, partner = nil)
    @pid = pid
    @regs = { 'p' => pid }
    @ip = 0
    @program = input.split("\n").map do |line|
      /([^\s]+)\s([^\s]+)(?:\s([^\s]+))?$/ =~ line
      { op: method($1.to_sym), op1: parse_operand($2), op2: parse_operand($3) }
    end
    @rcvd = []
    @sent = 0
    @partner = partner
    @blocked = false
  end

  def enqueue(value)
    @blocked = false
    @rcvd.push value
  end

  def launch
    while @ip >= 0 && @ip < @program.length
      @program[@ip][:op].call(@program[@ip][:op1], @program[@ip][:op2])
      @ip += 1 unless @ip < -1
    end
  end

  def snd(op1, _)
    @partner.enqueue value_from op1
    @sent += 1
  end

  def set(op1, op2)
    @regs[op1] = value_from op2
  end

  def add(op1, op2)
    @regs[op1] = value_from(op1) + value_from(op2)
  end

  def mul(op1, op2)
    @regs[op1] = value_from(op1) * value_from(op2)
  end

  def mod(op1, op2)
    @regs[op1] = value_from(op1) % value_from(op2)
  end

  def rcv(op1, _)
    if @rcvd.empty?
      @blocked = true
      @ip = -10 if @partner.blocked
      @partner.launch
    end
    @regs[op1] = @rcvd.shift
  end

  def jgz(op1, op2)
    @ip += value_from(op2) - 1 if value_from(op1) > 0
  end

  def parse_operand(operand)
    ('a'..'z').include?(operand) ? operand : operand.to_i if operand
  end

  def value_from(operand)
    operand.is_a?(Numeric) ? operand : (@regs[operand] ||= 0)
  end
end

class Adv18_b < TestFramework
  def logic(t)
    prog0 = Program.new 0, t
    prog1 = Program.new 1, t, prog0
    prog0.partner = prog1
    prog0.launch
    prog1.sent
  end
end

adva = Adv18_a.new({ 'set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
' => 4 }, 18)
# adva.test
# puts adva.run

advb = Adv18_b.new({ 'snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
' => 3 }, 18)
# advb.test
puts advb.run
