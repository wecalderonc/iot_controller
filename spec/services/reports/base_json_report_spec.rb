require 'rails_helper'

RSpec.describe Reports::BaseJsonReport do
  describe "#call" do
    let(:response) { subject.(input) }
    let!(:price)   { create(:price) }

    context "accumulator_model" do
      let(:input)    { { objects: ThingsQuery.new.sort_accumulators, model: :accumulator } }

      it "should return a csv file with thing's accumulators data"do
        accumulator = create :accumulator

        uplink = accumulator.uplink
        thing = uplink.thing
        date = uplink.created_at.strftime('%a %d %b %Y')

        thing.update(units: { liter: 300 })

        units = thing.units[:liter]
        
        value = (accumulator.value.to_i(16).to_f / units).round(2),

        expected_response = [
          {
            :thing_id => thing.id,
            :thing_name => thing.name,
            :accumulators => [{
              :date => date,
              :value => accumulator.value,
              :consumption_delta => (accumulator.value.to_i(16).to_f / units).round(2),
              :accumulated_delta => (accumulator.value.to_i(16).to_f / units).round(2)
            }]
          }
        ]

        expect(response).to match(expected_response)
      end
    end

    context "model alarm" do
      let(:input)    { { objects: ThingsQuery.new.sort_alarms, model: :alarm } }

      it "should return a json with thing's alarms data"do
        alarm = create :alarm
        uplink = alarm.uplink
        thing = uplink.thing
        date = uplink.created_at.strftime('%a %d %b %Y')

        expected_response = [
          {
            :thing_id => thing.id,
            :thing_name => thing.name,
            :alarms => [{
              :date => date,
              :value => alarm.value
            }]
          }
        ]

        expect(response).to match(expected_response)
      end
    end
  end
end
