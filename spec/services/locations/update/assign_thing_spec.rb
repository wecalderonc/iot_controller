require 'rails_helper'

RSpec.describe Locations::Update::AssignThing do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:user)     { create(:user, email: "user@gmail.com") }
    let(:country)  { create(:country, code_iso: 'CO') }
    let(:state)    { create(:state, code_iso: 'CO-DC', country: country) }
    let(:city)     { create(:city, name: 'Bogota', state: state) }
    let(:location) { create(:location, city: city) }
    let(:thing)    { create(:thing, locates: location) }

    let(:input) {
      { thing_name: thing.name,
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
          billing_period: :month,
          cut_day: 10,
          start_day: 10,
          start_month: 10,
          start_year: 2019
        },
        schedule_report: {
          email: 'unacosita@gmail.com',
          frequency_day: 1,
          frequency_interval: :week,
          start_day: 10,
          start_month: 10,
          start_year: 2019
        },
        thing: thing,
        user: user
      }
    }

    context "new_thing_name is present" do
      it "Should update the thing of location" do
        location.update(thing: nil)
        thing2 = create(:thing, name: 'new_name')
        input[:new_thing_name] = 'new_name'

        puts "*" * 100
        p location.thing
        p thing2.locates

        expect(response).to be_success
        location.reload

        puts "*" * 100
        p location.thing
        p thing2.locates

        expect(location.thing.name).to eq('new_name')
        expect(location.city.name).to eq('Bogota')
      end
    end

    context "new_thing_name is present but is wrong" do
      it "Should update the thing of location" do
        input[:new_thing_name] = 'invalid_name'

        expected_response = "The thing invalid_name does not exist"

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
        expect(location.city.name).to eq('Bogota')
      end
    end
  end
end
