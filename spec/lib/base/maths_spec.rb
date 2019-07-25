require 'rails_helper'

RSpec.describe Base::Maths do
  describe "#hexa_to_int" do
    it "Should return the hexa converted in to a integer" do
      value = "1"

      response = subject.hexa_to_int(value)

      expect(response).to eq(1)

      value = "A"

      response = subject.hexa_to_int(value)

      expect(response).to eq(10)

      value = "AA"

      response = subject.hexa_to_int(value)

      expect(response).to eq(170)
    end
  end

  describe "#RuleOfThree" do
    it "Should return the rule of three of those numbers" do
      a = 2
      b = 2
      c = 2

      response = subject::RuleOfThree.(a, b, c)

      expect(response).to eq(2)

      c = 1

      response = subject::RuleOfThree.(a, b, c)

      expect(response).to eq(4)
    end
  end
end
