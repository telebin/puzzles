class TestFramework
  def initialize test_cases
    @test_cases = test_cases
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

end