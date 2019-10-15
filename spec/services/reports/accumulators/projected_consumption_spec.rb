require 'rails_helper'

RSpec.describe Reports::Accumulators::ProjectedConsumption do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:location) { create(:location, schedule_billing: billing) }
    let(:thing)    { create(:thing, locates: location) }
    let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - (4.months - 8.days)) }

    context "current period has a consumption higher than 0" do
      let(:input)    { { thing: thing, consumptions_by_month: { '4': { value: 256, days_count: 20, months: [5, 6] } } } }

      it "should return a projected consumption higher than 0" do

        expected_response = {
          thing: thing,
          consumptions_by_month: {
            '4': {
              value: 256,
              days_count: 20,
              months: [5, 6]
            }
          },
          projected_consumption: {
            value: 384.0,
            days_count: 10
          }
        }

        expect(response).to eq(expected_response)
      end
    end

    context "current period has a consumption  lower than 1" do
      let(:input) { { thing: thing, consumptions_by_month: { '4': { value: 0, days_count: 20, months: [5, 6] } } } }

      it "should return a projected consumption lower than 1" do

        expected_response = {
          thing: thing,
          consumptions_by_month: {
            '4': {
              value: 0,
              days_count: 20,
              months: [5, 6]
            }
          },
          projected_consumption: {
            value: 0,
            days_count: 10
          }
        }

        expect(response).to eq(expected_response)
      end
    end
  end
end
