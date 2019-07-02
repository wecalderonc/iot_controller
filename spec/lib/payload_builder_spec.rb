require 'rails_helper'

RSpec.describe PayloadBuilder do
  describe "#" do
    it "Should return a hash" do
      response = subject.consume(value, last_accumulator)
      expected_response = "0" + "10000" + "3" + "ffff" + "2" + "1112"

      expect(response).to eq(expected_response)
    end
  end

  describe "#accumulate_value" do
    it "Should return a hash" do
      response = subject.accumulate_value(value)
      expected_response = "0" + "10000" + "3" + "0000" + "2" + "0001"

      expect(response).to eq(expected_response)
    end
  end
end
