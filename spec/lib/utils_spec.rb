require 'rails_helper'

RSpec.describe Utils do
  describe "#to_constant" do
    it "Should return a constant" do
      response = subject.to_constant(:thing)
      expected_response = Thing

      expect(response).to eq(expected_response)
    end
  end

  describe "#symbolize_values" do
    context "All the keys are in the hash" do
      it "Should return a hash with keys values converted to sym" do
        hash = { a: "perrito", b: 234, c: [1,2], d: "holi" }
        keys = [:a, :d]
        response = subject.symbolize_values(hash, keys)
        expected_response = { a: :perrito, b: 234, c: [1,2], d: :holi }

        expect(response).to eq(expected_response)
      end
    end

    context "some keys are in the hash" do
      it "Should return a hash with keys values converted to sym" do
        hash = { a: "perrito", b: 234, c: [1,2], d: "holi" }
        keys = [:a, :d, :e]
        response = subject.symbolize_values(hash, keys)
        expected_response = { a: :perrito, b: 234, c: [1,2], d: :holi }

        expect(response).to eq(expected_response)
      end
    end
  end

  describe "#parse_date" do
    let(:result) { described_class.parse_date(date) }

    context "uplink created_at is present" do
      let(:accumulator) { create(:accumulator) }
      let(:date) { accumulator.uplink.created_at }
      let(:parsed_date) { date.strftime('%a %d %b %Y') }

      it "should return uplink created_at" do
        expect(result).to eq(parsed_date)
      end
    end
    context "uplink created_at is present" do
      let(:accumulator) { create(:accumulator) }
      let(:date) { accumulator.uplink.created_at }

      it "should return uplink created_at" do
        accumulator.uplink.update(created_at: nil)

        expect(result).to eq("")
      end
    end
  end

  describe "#camelize_symbol" do
    it "Should return a camelized string" do
      response = subject.camelize_symbol(:thing)
      expected_response = "Thing"

      expect(response).to eq(expected_response)
    end
  end
end
