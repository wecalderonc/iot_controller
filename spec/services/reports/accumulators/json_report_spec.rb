require 'rails_helper'

RSpec.describe Reports::Accumulators::JsonReport do
  describe "#call" do
    let(:input)    { ThingsQuery.new.sort_accumulators }
    let(:response) { subject.(input) }

    it "should return a csv file with thing's accumulators data"do
      accumulator = create :accumulator

      uplink = accumulator.uplink
      thing = uplink.thing
      date = uplink.created_at.strftime('%a %d %b %Y')

      expected_response = [
        {
          "thing_id" => thing.id,
          "thing_name" => thing.name,
          "date" => date,
          "value" => accumulator.value
        },
        {
          "thing_id" => thing.id,
          "thing_name" => thing.name,
          "date" => date,
          "value" => accumulator2.value
        },
        {
          "thing_id" => thing.id,
          "thing_name" => thing.name,
          "date" => date,
          "value" => accumulator3.value
        }
      ]

      expect(response).to be_success
      expect(response.success).to include(expected_response)
    end
  end
end
