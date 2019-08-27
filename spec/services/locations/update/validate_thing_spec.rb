require 'rails_helper'

RSpec.describe Locations::Update::ValidateThing do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:user)     { create(:user, email: "user@gmail.com") }
    let(:location) { create(:location) }
    let(:thing)    { create(:thing, locates: location) }
    let(:country)  { create(:country, code_iso: 'CO') }
    let(:state)    { create(:state, code_iso: 'CO-DC', country: country) }
    let(:city)     { create(:city, name: 'Bogota', state: state) }
    let(:schedule_billing) { location.schedule_billing }
    let(:schedule_report) { location.schedule_report }

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
        },
        schedule_report: {
          email: 'unacosita@gmail.com',
          frequency_day: 1,
          frequency_interval: :week,
          start_day: 10,
          start_month: 10,
          start_year: 2019
        }
      }
    }

    contex "new_thing_name is present" do
      it "Should update the thing of location" do
        input[:new_thing_name] = 'new_name'

        expect(response).to be_success
     
        expect(response.success).to match(location)
        expect(locatio.thing.name).to match('new_name')
        expect(location.city.name).to eq('Bogota')
        expect(schedule_billing.stratum).to eq(5)
        expect(schedule_report.email).to eq('unacosita@gmail.com')
      end
    end

    contex "new_thing_name is empty" do
      it "Should delete relationship between thing and location" do
        input[:new_thing_name] = ''

        expect(response).to be_success
     
        expect(response.success).to match(location)
        expect(location.thing).to be_nil
        expect(location.city.name).to eq('Bogota')
        expect(schedule_billing.stratum).to eq(5)
        expect(schedule_report.email).to eq('unacosita@gmail.com')
      end
    end

    contex "new_thing_name isn't present" do
      it "Should return original input" do
        expect(response).to be_success
     
        expect(response.success).to match(location)
        expect(location.thing).to be_nil
        expect(location.city.name).to eq('Bogota')
        expect(schedule_billing.stratum).to eq(5)
        expect(schedule_report.email).to eq('unacosita@gmail.com')
      end
    end
  end
end
