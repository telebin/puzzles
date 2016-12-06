class TestFramework
  @test_cases = {}

  def initialize test_cases
    @test_cases = test_cases
  end

  def test
    @test_cases.each do |c, r|
      puts "testing \"#{c}\":"
      act = logic c
      if r == act
        puts "#{act} ok"
      else
        puts "#{act} ain't #{r}"
      end
    end
  end

  def logic(arg)
    raise 'Not implemented'
  end

end