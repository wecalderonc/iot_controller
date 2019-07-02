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
end
