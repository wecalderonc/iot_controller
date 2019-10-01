require 'rails_helper'

RSpec.describe Reports::Accumulators::JsonReport do
  describe "#call" do
    let(:input)    { ThingsQuery.new.sort_alarms }
    let(:response) { subject.(input) }

    it "should return a csv file with thing's accumulators data"do
      accumulator = create :accumulator

      uplink = accumulator.uplink
      thing = uplink.thing
      date = uplink.created_at.strftime('%a %d %b %Y')

      expected_response = [
        {
          :thing_id => thing.id,
          :thing_name => thing.name,
          :alarms => [{
            :date => date,
            :value => accumulator.value
          }]
        }
      ]

      expect(response).to match(expected_response)
    end
  end
end
