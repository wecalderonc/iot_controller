require 'rails_helper'

describe ThingsQuery do
  describe "#sort_accumulators" do
    let(:subject) { described_class }

    context "all things" do
      let(:response) { subject.sort_accumulators }
      it "return all things with accumulators sorted by thing" do
        create :accumulator

        expect(response.count).to eq(1)
        expect(response.values.count).to eq(1)
      end
    end

    context "specific thing" do
      let(:accumulator) { create(:accumulator) }
      let(:thing)       { accumulator.uplink.thing }
      let(:response)    { subject.sort_accumulators(thing) }

      it "return speficif thing with accumulators sorted by thing" do
        expect(response.count).to eq(1)
        expect(response.values.count).to eq(1)
      end
    end
  end
end
