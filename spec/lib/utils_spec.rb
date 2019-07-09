require 'rails_helper'

RSpec.describe Utils do
  describe "#to_constant" do
    it "Should return a constant" do
      response = subject.to_constant!(:thing)
      expected_response = Thing

      expect(response).to eq(expected_response)
    end
  end

  describe "#symbolize_values" do
    context "All the keys are in the hash" do
      it "Should return a hash with keys values converted to sym" do
        hash = { a: "perrito", b: 234, c: [1,2], d: "holi" }
        keys = [:a, :d]
        response = subject.symbolize_values!(hash, keys)
        expected_response = { a: :perrito, b: 234, c: [1,2], d: :holi }

        expect(response).to eq(expected_response)
      end
    end

    context "some keys are in the hash" do
      it "Should return a hash with keys values converted to sym" do
        hash = { a: "perrito", b: 234, c: [1,2], d: "holi" }
        keys = [:a, :d, :e]
        response = subject.symbolize_values!(hash, keys)
        expected_response = { a: :perrito, b: 234, c: [1,2], d: :holi }

        expect(response).to eq(expected_response)
      end
    end
  end
end
