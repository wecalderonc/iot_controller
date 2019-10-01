require 'rails_helper'

RSpec.describe Reports::Alarms::JsonReport do
  describe "#call" do
    let(:input)    { ThingsQuery.new.sort_alarms }
    let(:response) { subject.(input) }

    it "should return a csv file with thing's alarms data"do
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
