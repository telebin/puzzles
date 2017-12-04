class TestFramework
  def initialize(test_cases, day_to_input = nil)
    @test_cases = test_cases
    @day = day_to_input
  end

  def test
    @test_cases.each do |c, r|
      puts "testing \"#{c}\":"
      act = logic c
      puts r == act ? "#{act} ok" : "#{act} ain't #{r}"
    end
  end

  def logic(arg)
    raise 'Not implemented'
  end

  def run(arg = nil)
    raise 'Neither argument nor day to read' unless @day or arg
    logic (arg or File.open("inputs/day#{@day}.txt") {|f| f.readlines.chomp})
  end
end
