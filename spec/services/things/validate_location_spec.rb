require 'rails_helper'

RSpec.describe Things::ValidateLocation do
  describe '#call' do
    let(:response) { subject.(input) }

    context "When the thing doesnt have a location already" do
      let(:user)    { create(:user, email: "user@gmail.com") }
      let(:thing)   { create(:thing) }
      let(:country) { create(:country, code_iso: 'CO') }
      let(:state)   { create(:state, code_iso: 'CO-DC', country: country) }
      let(:city)    { create(:city, name: 'Bogota', state: state) }

      let(:input) {
        { thing_name: thing.name,
          email: user.email,
          location: {
            name: 'My house',
            address: 'Carrera 7 # 71 - 21',
            latitude: 4.606880,
            longitude: -74.071840
          },
          country_state_city: {
            country: 'CO',
            state: 'CO-DC',
            city: city.name
          },
          schedule_billing: {
            stratum: 5,
            basic_charge_price: 13.841,
            top_limit: 40.0,
            basic_price: 2.000,
            extra_price: 2.500,
            billing_frequency: 2,
            billing_period: 'month',
            cut_day: 10,
            start_day: 10,
            start_month: 10,
            start_year: 2019
          },
          schedule_report: {
            email: 'unacosita@gmail.com',
            frequency_day: 1,
            frequency_interval: 'week',
            start_day: 10,
            start_month: 10,
            start_year: 2019
          },
          thing: thing
        }
      }

      it "Should return a success response" do
        expect(response).to be_success
        expect(response.success).to eq(input)

      end
    end

    context "When the THING already has another location" do
      let(:user)    { create(:user, email: "user@gmail.com") }
      let(:location) { create(:location, :with_thing) }
      let!(:thing2)   { location.thing }
      let(:country) { create(:country, code_iso: 'CO') }
      let(:state)   { create(:state, code_iso: 'CO-DC', country: country) }
      let(:city)    { create(:city, name: 'Bogota', state: state) }

      let(:input) {
        { thing_name: thing2.name,
          email: user.email,
          location: {
            name: 'My house',
            address: 'Carrera 7 # 71 - 21',
            latitude: 4.606880,
            longitude: -74.071840
          },
          country_state_city: {
            country: 'CO',
            state: 'CO-DC',
            city: city.name
          },
          schedule_billing: {
            stratum: 5,
            basic_charge_price: 13.841,
            top_limit: 40.0,
            basic_price: 2.000,
            extra_price: 2.500,
            billing_frequency: 2,
            billing_period: 'month',
            cut_day: 10,
            start_day: 10,
            start_month: 10,
            start_year: 2019
          },
          schedule_report: {
            email: 'unacosita@gmail.com',
            frequency_day: 1,
            frequency_interval: 'week',
            start_day: 10,
            start_month: 10,
            start_year: 2019
          },
          thing: thing2
        }
      }
      it "Should return a Failure response and a message" do
        expected_response = "The thing #{thing2.name} is already located in another place"

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end
  end
end
