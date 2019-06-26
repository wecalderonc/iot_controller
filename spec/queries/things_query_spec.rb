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
      end
      context "things not found" do
        it "return empty hash response" do
          expect(response.count).to be_zero
          expect(response).to eq({})
        end
      end
    end

    context "specific thing" do
      let(:response)    { described_class.new(thing).sort_accumulators }

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

        it "return empty hash response" do
          expect(response.count).to be_zero
          expect(response).to eq({})
        end
      end
    end
  end

  describe "#sort_alarms" do

    context "all things" do
      let(:response) { subject.sort_alarms }

      context "things found" do
        it "return all things with alarms sorted by thing" do
          create :alarm

          expect(response.count).to eq(1)
          expect(response.values.count).to eq(1)
        end
      end
      context "things not found" do
        it "return empty hash response" do
          expect(response.count).to be_zero
          expect(response).to eq({})
        end
      end
    end

    context "specific thing" do
      let(:response)    { described_class.new(thing).sort_alarms }

      context "thing has alarms" do
        let(:alarm) { create(:alarm) }
        let(:thing)       { alarm.uplink.thing }

        it "return speficif thing with alarm sorted by thing" do
          expect(response.count).to eq(1)
          expect(response.values.count).to eq(1)
        end
      end
      context "thing hasn't alarms" do
        let(:thing)       { create(:thing) }

        it "rutern empty hash response" do
          expect(response.count).to be_zero
          expect(response).to eq({})
        end
      end
    end
  end
end
