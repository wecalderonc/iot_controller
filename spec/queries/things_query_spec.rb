require 'rails_helper'

describe ThingsQuery do
  describe "#with_accumulators" do
    subject(:with_accumulators) { described_class.with_accumulators }

    it "return all things with accumulators sorted by thing id" do
      create :accumulator

      expect(with_accumulators.count).to eq(1)
      expect(with_accumulators.values.count).to eq(1)
    end
  end
end
