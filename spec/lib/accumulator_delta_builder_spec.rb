require 'rails_helper'

RSpec.describe AccumulatorDeltaBuilder do
  let(:result) { subject.(input) }
  let(:input) { Accumulator.all.order('n.value') }

  describe "#call" do
    context "when input quantity is one" do
      it "should return a 0 delta and accumulated result value" do
        accumulator = create :accumulator, value: "00006fff"

        expect(result.count).to eq(1)
        expect(result.first[:delta]).to eq(0)
        expect(result.first[:accumulated]).to eq(0)
      end
    end

    context "when input quantity more than one" do
      it "should return deltas and accumulated results values" do
        accumulator1 = create :accumulator, value: "00006fff"
        accumulator2 = create :accumulator, value: "00007fff"
        accumulator3 = create :accumulator, value: "00008fff"

        expect(result.count).to eq(3)
        expect(result).to match_array([{:delta=>0, :accumulated=>0}, {:delta=>4096, :accumulated=>4096}, {:delta=>4096, :accumulated=>8192}])
      end
    end
  end
end
