require 'rails_helper'

RSpec.describe Locations::Create::CreateScheduleBilling do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:input) {
      {
        location: location,
        schedule_billing: {
          stratum: 5,
          basic_charge: 13.841,
          top_limit: 40.0,
          basic_price: 2.000,
          extra_price: 2.500,
          billing_frequency: 2,
          billing_period: :month,
          cut_day: 10,
          start_day: 10,
          start_month: 10,
          start_year: 2019
        }
      }
    }

    context 'Creating a new schedule billing' do
      let(:location) { create(:location) }
      let(:schedule_billing) { location.schedule_billing }

      it 'should create a new schedule billing' do
        expect(response).to be_success

        expected_response = {
          location: location,
          schedule_billing: schedule_billing
        }

        expect(response.success).to match(expected_response)
        expect(schedule_billing.stratum).to eq(5)
        expect(schedule_billing.top_limit).to eq(40.0)
      end
    end
  end
end
