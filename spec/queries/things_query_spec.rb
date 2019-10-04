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

  describe "#date_uplinks_filter" do
    let(:response) { subject.date_uplinks_filter(date, model) }

    context "all things" do
      let(:start_date) { (Time.now - 2.days).to_time.to_i.to_s }
      let(:end_date)   { Time.now.to_time.to_i.to_s }
      let(:date)       { { start_date: start_date, end_date: end_date } }
      let(:model)      { :alarm }
      let(:uplink)     { create(:uplink, time: end_date) }
      let!(:alarm2)    { create(:alarm) }

      context "there are uplinks with that date" do
        let!(:alarm)     { create(:alarm, uplink: uplink) }

        it "should return objects filtered by date" do
          expect(response.count).to eq(1)
          expect(response.values.count).to eq(1)
          expect(response.values.first).to include(alarm)
        end
      end

      context "there aren't uplinks with that date" do
        it "should return a empty response" do
          expect(response.count).to be_zero
          expect(response).to eq({})
        end
      end
    end

    context "specific thing" do
      let(:subject) { described_class.new(uplink.thing) }
      let(:start_date) { (Time.now - 2.days).to_time.to_i.to_s }
      let(:end_date)   { Time.now.to_time.to_i.to_s }
      let(:date)       { { start_date: start_date, end_date: end_date } }
      let(:model)      { :alarm }
      let(:uplink)     { create(:uplink, time: end_date) }
      let!(:alarm2)    { create(:alarm) }

      context "there are uplinks with that date" do
        let!(:alarm)     { create(:alarm, uplink: uplink) }
        it "should return objects filtered by date" do
          expect(response.count).to eq(1)
          expect(response.values.count).to eq(1)
          expect(response.values.first).to include(alarm)
        end
      end

      context "there aren't uplinks with that date" do
        it "should return a empty response" do
          expect(response.count).to be_zero
          expect(response).to eq({})
        end
      end
    end
  end
end
