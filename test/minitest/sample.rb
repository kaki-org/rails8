require "minitest/autorun"

class Person
  def hello; 'hello' end
end

class TestPerson < Minitest::Test
  def setup
    @person = Person.new
  end

  def test_hello
    assert_equal 'hello', @person.hello
  end
end
