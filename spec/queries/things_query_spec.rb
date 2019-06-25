require 'rails_helper'

describe ThingsQuery do
  describe "#sort_accumulators" do

    context "all things" do
      let(:response) { subject.sort_accumulators }
      context "things found" do
        it "return all things with accumulators sorted by thing" do
          create :accumulator

          expect(response.count).to eq(1)
          expect(response.values.count).to eq(1)
        end
      context "things not found" do
        it "return empty hash response" do

          expect(response.count).to eq(0)
          expect(response).to eq({})
        end
      end
      end
    end

    context "specific thing" do
      let(:response)    { subject.sort_accumulators(thing) }

      context "thing has accumulators" do
        let(:accumulator) { create(:accumulator) }
        let(:thing)       { accumulator.uplink.thing }

        it "return speficif thing with accumulators sorted by thing" do
          expect(response.count).to eq(1)
          expect(response.values.count).to eq(1)
        end
      end
      context "thing hasn't accumulators" do
        let(:thing)       { create(:thing) }

        it "return speficif thing with accumulators sorted by thing" do
          expect(response.count).to eq(0)
          expect(response).to eq({})
        end
      end
    end
  end
end
