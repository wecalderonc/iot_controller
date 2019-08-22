require 'swagger_helper'

RSpec.describe "Locations API", :type => :request do
  path "/api/v1/locations" do
    post 'create location' do
      tags 'Locations'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          location: {
            type: :object,
            properties: {
              name: { type: :string },
              address: { type: :string },
              latitude: { type: :float },
              longitude: { type: :float }
            }
          },
          country_state_city: {
            type: :object,
            properties: {
              country: { type: :string },
              state: { type: :string },
              city: { type: :string }
            }
          },
          schedule_billing: {
            type: :object,
            properties: {
              stratum: { type: :integer },
              basic_charge: { type: :float },
              top_limit: { type: :float },
              basic_price: { type: :float },
              extra_price: { type: :float },
              billing_frequency: { type: :integer },
              billing_period: { type: :string },
              cut_day: { type: :integer },
              start_day: { type: :integer },
              start_month: { type: :integer },
              start_year: { type: :integer }
            }
          },
          schedule_report: {
            type: :object,
            properties: {
              email: { type: :string },
              frequency_day: { type: :integer },
              frequency_interval: { type: :string },
              start_day: { type: :integer },
              start_month: { type: :integer },
              start_year: { type: :integer }
            }
          }
        },
        required: [ 'location', 'country_state_city', 'schedule_billing', 'schedule_report']
      }

      response '200', 'location created' do
        let(:user)     { create(:user) }
        let(:header)   { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }), 'Content-Type' => "application/json" } }
        let(:country)  { create(:country, code_iso: 'CO') }
        let(:state)    { create(:state, code_iso: 'CO-DC', country: country) }
        let(:city)     { create(:city, name: 'Bogota', state: state) }
        let(:thing)    { create(:thing) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: [ 'name', 'address', 'latitude', 'longitude', 'country', 'state', 'city', 'schedule_billing', 'schedule_report' ],
          properties: {
            type: :object,
            properties: {
              name: { type: :string },
              address: { type: :string },
              latitude: { type: :float },
              longitude: { type: :float },
              country: { type: :string },
              state: { type: :string },
              city: { type: :string },
              schedule_billing: {
                type: :object,
                properties: {
                  stratum: { type: :integer },
                  basic_charge: { type: :float },
                  top_limit: { type: :float },
                  basic_price: { type: :float },
                  extra_price: { type: :float },
                  billing_frequency: { type: :integer },
                  billing_period: { type: :string },
                  cut_day: { type: :integer },
                  start_date: { type: :string }
                }
              },
              schedule_report: {
                type: :object,
                properties: {
                  email: { type: :string },
                  frequency_day: { type: :integer },
                  frequency_interval: { type: :string },
                  start_date: { type: :string }
                }
              }
            }
          }

        let(:input) {{
          thing_name: thing.name,
          location: {
            name: 'My house',
            address: 'Carrera 7 # 71 - 21',
            latitude: 84.606880,
            longitude: -94.071840
          },
          country_state_city: {
            country: country.code_iso,
            state: state.code_iso,
            city: city.name
          },
          schedule_billing: {
            stratum: 5,
            basic_charge: 13.841,
            top_limit: 40.0,
            basic_price: 2000.0,
            extra_price: 2500.0,
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
          }
        }}

        run_test!
      end
      response '404', 'thing not found' do
        let(:user)     { create(:user) }
        let(:header)   { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }), 'Content-Type' => "application/json" } }
        let(:country)  { create(:country, code_iso: 'CO') }
        let(:state)    { create(:state, code_iso: 'CO-DC', country: country) }
        let(:city)     { create(:city, name: 'Bogota', state: state) }
        let(:thing)    { create(:thing) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: [ 'errors' ],
          properties: {
            type: :object,
            properties: {
              errors: { type: :string },
            }
          }

        let(:input) {{
          thing_name: 'invalid_name',
          location: {
            name: 'My house',
            address: 'Carrera 7 # 71 - 21',
            latitude: 84.606880,
            longitude: -94.071840
          },
          country_state_city: {
            country: country.code_iso,
            state: state.code_iso,
            city: city.name
          },
          schedule_billing: {
            stratum: 5,
            basic_charge: 13.841,
            top_limit: 40.0,
            basic_price: 2000.0,
            extra_price: 2500.0,
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
          }
        }}

        run_test!
      end
    end
  end
end
