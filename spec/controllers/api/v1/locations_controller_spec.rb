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
          "city" => {
            "name" => city.name,
          },
          "schedule_billing" => {
            "stratum" => 5,
            "basic_charge" => 13.841,
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
            basic_charge: 13.841,
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
    let(:thing)    { create(:thing) }
    let(:location) { thing.locates }

    context "Right params" do
      it "Should update a location with his relationships" do

        body = {
          thing_name: thing.name,
          new_thing_name: 'New name',
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
        }.to_json

        post '/api/v1/locations', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expected_response = {
          "thing_name" => thing.name,
          "name" => 'My house',
          "address" => 'Carrera 7 # 71 - 21',
          "latitude" => 84.606880,
          "longitude" => -94.071840,
          "city" => {
            "name" => city.name,
          },
          "schedule_billing" => {
            "stratum" => 5,
            "basic_charge" => 13.841,
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

    context "Update Location process failure with wrong params" do
      it "Should return error message" do

        body = {
          thing_name: thing.name,
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
            basic_charge: 13.841,
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
end
