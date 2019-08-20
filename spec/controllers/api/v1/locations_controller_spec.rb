require 'rails_helper'

RSpec.describe Api::V1::LocationsController, :type => :request do
  describe "POST/create location" do
    let(:country) { create(:country, code_iso: 'CO') }

    context "Right params" do
      it "Should create a new location with his relationships" do

        body = {
          thing_id: thing.id,
          location: {
            name: 'My house',
            address: 'Carrera 7 # 71 - 21',
            latitude: '4.606880',
            longitude: '-74.071840'
          },
          country_state_city: {
            country: 'Colombia',
            state: 'Bogota DC',
            city: 'Bogota'
          },
          schedule_billing: {
            stratum: 5,
            basic_charge: 13.841,
            top_limit: 40,
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
            frequency_day: 'monday',
            frequency_interval: 'week',
            start_day: 10,
            start_month: 10,
            start_year: 2019
          }
        }

        post '/api/v1/locations', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response = {
          location: {
            name: 'My house',
            address: 'Carrera 7 # 71 - 21',
            latitude: '4.606880',
            longitude: '-74.071840'
          },
          country_state_city: {
            country: 'Colombia',
            state: 'Bogota DC',
            city: 'Bogota'
          },
          schedule_billing: {
            stratum: 5,
            basic_charge: 13.841,
            top_limit: 40,
            basic_price: 2.000,
            extra_price: 2.500,
            billing_frequency: 2,
            billing_period: 'mes',
            cut_day: 10,
            start_date: DateTime.new(2019, 10, 10)
          },
          schedule_report: {
            email: 'unacosita@gmail.com',
            frequency_day: 'monday',
            frequency_interval: 'week',
            start_date: DateTime.new(2019, 10, 10)
          }
        }

        expect(response_body).to eq(expected_response)
      end
    end
  end
end
