require 'rails_helper'

RSpec.describe Api::V1::LocationsController, :type => :request do
  describe "POST/create location" do
    let(:user)     { create(:user) }
    let(:header)   { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }), 'Content-Type' => "application/json" } }
    let(:country)  { create(:country, code_iso: 'CO') }
    let(:state)    { create(:state, code_iso: 'CO-DC', country: country) }
    let(:city)     { create(:city, name: 'Bogota', state: state) }
    let(:thing)    { create(:thing) }
    let(:location) { thing.locates }

    context "Right params" do
      it "Should create a new location with his relationships" do

        body = {
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
        }.to_json

        post '/api/v1/locations', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response = {
          "name" => 'My house',
          "address" => 'Carrera 7 # 71 - 21',
          "latitude" => 84.606880,
          "longitude" => -94.071840,
          "country_iso" => city.state.country.code_iso,
          "state_iso" => city.state.code_iso,
          "city" => {
            "name" => city.name,
          },
          "schedule_billing" => {
            "stratum" => 5,
            "basic_charge_price" => 13.841,
            "top_limit" => 40.0,
            "basic_price" => 2000.0,
            "extra_price" => 2500.0,
            "billing_frequency" => 2,
            "billing_period" => 'month',
            "cut_day" => 10,
            "start_date" => "2019-10-10"
          },
          "schedule_report" => {
            "email" => 'unacosita@gmail.com',
            "frequency_day" => 1,
            "frequency_interval" => 'week',
            "start_date" => location.schedule_report.start_date
          }
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "Create Location process failure with wrong params" do
      it "Should return error message" do

        body = {
          thing_name: thing.name,
          email: user.email,
          location: {
            name: 123,
            address: 'Carrera 7 # 71 - 21',
            latitude: 2,
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
            cut_day: 'holii',
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
        }.to_json


        post '/api/v1/locations', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response =
          {
            "errors" => {
              "location"=>{
                "latitude"=>["must be Float"],
                "name"=>["must be String"]
              },
              "schedule_billing"=>{
                "cut_day"=>["must be Integer"]
              }
            }
          }

        expect(response_body).to eq(expected_response)
      end
    end
  end

  describe "PUT/update location" do
    let(:user)     { create(:user) }
    let(:header)   { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }), 'Content-Type' => "application/json" } }
    let(:country)  { create(:country, code_iso: 'CO') }
    let(:state)    { create(:state, code_iso: 'CO-DC', country: country) }
    let(:city)     { create(:city, name: 'Bogota', state: state) }
    let(:location) { create(:location, city: city) }
    let(:thing)    { create(:thing, locates: location) }

    context "Right params" do
      it "Should update a location with his relationships" do
        create(:thing, name: 'new_name')

        body = {
          thing_name: thing.name,
          email: user.email,
          new_thing_name: 'new_name',
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
            start_day: 11,
            start_month: 9,
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
        }.to_json

        put "/api/v1/locations/#{thing.name}", headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response = {
          "name" => 'My house',
          "address" => 'Carrera 7 # 71 - 21',
          "latitude" => 84.606880,
          "longitude" => -94.071840,
          "country_iso" => city.state.country.code_iso,
          "state_iso" => city.state.code_iso,
          "city" => {
            "name" => city.name,
          },
          "schedule_billing" => {
            "stratum" => 5,
            "basic_charge_price" => 13.841,
            "top_limit" => 40.0,
            "basic_price" => 2000.0,
            "extra_price" => 2500.0,
            "billing_frequency" => 2,
            "billing_period" => 'month',
            "cut_day" => 10,
            "start_date" => "2019-09-11"
          },
          "schedule_report" => {
            "email" => 'unacosita@gmail.com',
            "frequency_day" => 1,
            "frequency_interval" => 'week',
            "start_date" => location.schedule_report.start_date
          }
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "Update Location process failure with wrong params" do
      it "Should return error message" do

        body = {
          thing_name: thing.name,
          email: user.email,
          location: {
            name: 123,
            address: 'Carrera 7 # 71 - 21',
            latitude: 2,
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
            cut_day: 'holii',
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
        }.to_json


        put "/api/v1/locations/#{thing.name}", headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response =
          {
            "errors" => {
              "location"=>{
                "latitude"=>["must be Float"],
                "name"=>["must be String"]
              },
              "schedule_billing"=>{
                "cut_day"=>["must be Integer"]
              }
            }
          }

        expect(response_body).to eq(expected_response)
      end
    end
  end

  describe "GET/show location" do
    let(:user)     { create(:user) }
    let(:location) { create(:location, city: city) }
    let(:thing)    { create(:thing, locates: location) }
    let(:city)     { create(:city) }
    let(:header)   { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

    context "There is one thing with their location" do
      it "Should return an array with the location of a one thing" do
        Owner.create(from_node: user, to_node: thing)
        thing_name = thing.name

        get "/api/v1/locations/#{thing_name}", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")

        expected_response = {
          "address" => location.address,
          "latitude" => location.latitude,
          "longitude" => location.longitude,
          "name" => location.name,
          "country_iso" => city.state.country.code_iso,
          "state_iso" => city.state.code_iso,
          "city" => {
            "name" => city.name,
          },
          "schedule_billing" => {
            "stratum" => location.schedule_billing.stratum,
            "basic_charge_price" => location.schedule_billing.basic_charge_price,
            "top_limit" => location.schedule_billing.top_limit,
            "basic_price" => location.schedule_billing.basic_price,
            "extra_price" => location.schedule_billing.extra_price,
            "billing_frequency" => location.schedule_billing.billing_frequency,
            "billing_period" => location.schedule_billing.billing_period,
            "cut_day" => location.schedule_billing.cut_day,
            "start_date" => JSON.parse(location.schedule_billing.start_date.to_json)
          },
          "schedule_report" => {
            "email" => location.schedule_report.email,
            "frequency_day" => location.schedule_report.frequency_day,
            "frequency_interval" => location.schedule_report.frequency_interval,
            "start_date" => location.schedule_report.start_date
          }
        }

        expect(body).to eq(expected_response)
        expect(response.status).to eq(200)
      end
    end

    context "Thing name don't exist" do
      it "Should return a message thing does not exist" do
        Owner.create(from_node: user, to_node: thing)
        thing_name = thing.name

        get "/api/v1/locations/wrongname", headers: header


        parsed_response = JSON.parse(response.body)

        expected_response = "The thing wrongname does not exist"
        expect(parsed_response["errors"]).to eq(expected_response)
        expect(response.status).to eq(404)
      end
    end

    context "Thing has no associated location" do
      it "Should return a message of location not found" do
        Owner.create(from_node: user, to_node: thing)
        thing = create(:thing)

        get "/api/v1/locations/#{thing.name}", headers: header

        parsed_response = JSON.parse(response.body)

        expected_response = "The thing #{thing.name} does not have location"
        expect(parsed_response["errors"]).to eq(expected_response)
        expect(response.status).to eq(404)
      end
    end
  end
end
