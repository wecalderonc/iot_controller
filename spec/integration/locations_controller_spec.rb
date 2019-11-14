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
              basic_charge_price: { type: :float },
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
        let!(:owner)   { Owner.create(from_node: user, to_node: thing) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: [ 'name', 'address', 'latitude', 'longitude', 'city', 'schedule_billing', 'schedule_report' ],
          properties: {
            type: :object,
            properties: {
              name: { type: :string },
              address: { type: :string },
              latitude: { type: :float },
              longitude: { type: :float },
              city: {
                type: :object,
                properties: {
                  name: { type: :string }
                }
              },
              schedule_billing: {
                type: :object,
                properties: {
                  stratum: { type: :integer },
                  basic_charge_price: { type: :float },
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
          email: user.email,
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
            basic_charge_price: 13.841,
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
          email: user.email,
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
            basic_charge_price: 13.841,
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

  path "/api/v1/locations/{thing_name}" do
    put 'update location' do
      tags 'Locations'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          new_thing_name: { type: :string },
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
              basic_charge_price: { type: :float },
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
        required: [ 'new_thing_name', 'location', 'country_state_city', 'schedule_billing', 'schedule_report']
      }

      response '200', 'location updated' do
        let(:user)     { create(:user) }
        let(:header)   { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }), 'Content-Type' => "application/json" } }
        let(:country)  { create(:country, code_iso: 'CO') }
        let(:state)    { create(:state, code_iso: 'CO-DC', country: country) }
        let(:city)     { create(:city, name: 'Bogota', state: state) }
        let(:location) { create(:location, city: city) }
        let(:thing)    { create(:thing, locates: location) }
        let(:thing2)   { create(:thing, name: 'new_name') }
        let(:thing_name) { thing.name }
        let!(:owner)   { Owner.create(from_node: user, to_node: thing2) }
        let!(:owner2)   { Owner.create(from_node: user, to_node: thing) }

        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: [ 'name', 'address', 'latitude', 'longitude', 'city', 'schedule_billing', 'schedule_report' ],
          properties: {
            type: :object,
            properties: {
              name: { type: :string },
              address: { type: :string },
              latitude: { type: :float },
              longitude: { type: :float },
              city: {
                type: :object,
                properties: {
                  name: { type: :string }
                }
              },
              schedule_billing: {
                type: :object,
                properties: {
                  stratum: { type: :integer },
                  basic_charge_price: { type: :float },
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
          new_thing_name: thing2.name,
          email: user.email,
          location: {
            name: 'Other house',
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
            basic_charge_price: 13.841,
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
        let(:thing_name) { 'invalid_name' }
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
            basic_charge_price: 13.841,
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

  path "/api/v1/locations/{thing_name}" do
    get 'get location' do
      tags 'Locations'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'location founded' do
        let(:user)       { create(:user) }
        let(:location)   { create(:location, city: city) }
        let(:thing)      { create(:thing, locates: location) }
        let(:thing_name) { thing.name }
        let(:city)       { create(:city) }
        let!(:owner)     { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: [ 'name', 'address', 'latitude', 'longitude', 'city', 'schedule_billing', 'schedule_report' ],
          properties: {
            type: :object,
            properties: {
              name: { type: :string },
              address: { type: :string },
              latitude: { type: :float },
              longitude: { type: :float },
              city: {
                type: :object,
                properties: {
                  name: { type: :string }
                }
              },
              schedule_billing: {
                type: :object,
                properties: {
                  stratum: { type: :integer },
                  basic_charge_price: { type: :float },
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

        run_test!
      end

      response '401', 'Token is missing' do
        let(:user)       { create(:user) }
        let(:location)   { create(:location, city: city) }
        let(:thing)      { create(:thing, locates: location) }
        let(:thing_name) { thing.name }
        let(:city)       { create(:city) }
        let!(:owner)     { Owner.create(from_node: user, to_node: thing) }

        let(:'Authorization') { "Access denied!" }

        run_test!
      end

       response '404', 'thing not found' do
        let(:user)       { create(:user) }
        let(:location)   { create(:location, city: city) }
        let(:thing)      { create(:thing, locates: location) }
        let(:thing_name) { thing.name }
        let(:city)       { create(:city) }
        let!(:owner)     { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing_name) { "wrong_name" }

        run_test!
      end

      response '404', 'location not found' do
        let(:user)       { create(:user) }
        let(:thing)      { create(:thing) }
        let!(:owner)     { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing_name) { thing.name }

        run_test!
      end
    end
  end

  path "/api/v1/users/{email}/locations" do
    get 'get index locations' do
      tags 'Locations'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :email, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'location founded' do
        let(:user)            { create(:user) }
        let(:email)           { user.email }
        let(:location)        { create(:location, city: city) }
        let(:thing)           { create(:thing, locates: location) }
        let(:city)            { create(:city) }
        let!(:user_location)  { UserLocation.create(from_node: user, to_node: location) }
        let!(:thing_location) { ThingLocation.create(from_node: thing, to_node: location) }
        let!(:owner)          { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          required: [ 'name', 'thing' ],
          properties: {
            name: { type: :string },
            thing: {
              type: :object,
              properties: {
                id: { type: :string },
                name: { type: :string },
                new_alarms: { type: :boolean },
                last_battery_level: {
                  type: :object,
                  properties: {
                    id: { type: :string },
                    value: { type: :string },
                    created_at: { type: :string },
                    updated_at: { type: :string },
                    level_label: { type: :string }
                  }
                },
                valve_transition: {
                  type: :object,
                  properties: {
                    real_state: { type: :string },
                    showed_state: { type: :string }
                  }
                }
              }
            }
          }
        }

        run_test!
      end

      response '401', 'Token is missing' do
        let(:user)            { create(:user) }
        let(:email)           { user.email }
        let(:location)        { create(:location, city: city) }
        let(:thing)           { create(:thing, locates: location) }
        let(:thing_name)      { thing.name }
        let(:city)            { create(:city) }
        let!(:user_location)  { UserLocation.create(from_node: user, to_node: location) }

        let(:'Authorization') { "Access denied!" }

        run_test!
      end

      response '404', 'locations not found' do
        let(:user)       { create(:user) }
        let(:email)      { user.email }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        run_test!
      end
    end
  end
end
