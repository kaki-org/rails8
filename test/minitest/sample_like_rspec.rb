require "minitest/autorun"

class Person
  def hello; 'hello' end
end

describe Person do
  describe '#hello' do
    before { @person = Person.new }

    it 'should say hello' do
      _(@person.hello).must_equal 'hello'
    end
  end
end
