require 'rails_helper'

RSpec.describe Reports::BaseJsonReport do
  describe "#call" do
    let(:response) { subject.(input) }

    context "accumulator_model" do
      let(:input)    { { objects: ThingsQuery.new.sort_accumulators, model: :accumulator } }

      it "should return a csv file with thing's accumulators data"do
        accumulator = create :accumulator
     
        uplink = accumulator.uplink
        thing = uplink.thing
        date = uplink.created_at.strftime('%a %d %b %Y')
     
        expected_response = [
          {
            :thing_id => thing.id,
            :thing_name => thing.name,
            :accumulators => [{
              :date => date,
              :value => accumulator.value,
              :consumption_delta => 0,
              :accumulated_delta => 0
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
