require 'rails_helper'

RSpec.describe Api::V1::ThingsController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }), 'HTTP_ACCEPT' => "application/json" } }

  describe "GET/index things" do

    context "User doesn't have related things" do
      it "Should return empty array" do
        get '/api/v1/things', headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = []
        expect(body).to eq(expected_response)
      end
    end

    context "There is one thing related to user" do
      it "Should return an array with one thing" do
        thing = create(:thing)
        Owner.create(from_node: user, to_node: thing)

        get '/api/v1/things', headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = {
          "id" => thing.id,
          "name" => thing.name,
          "status" => thing.status,
          "pac" => thing.pac,
          "company_id" => thing.company_id,
          "units" => thing.units,
          "latitude" => thing.latitude,
          "longitude" => thing.longitude,
          "created_at" => JSON.parse(thing.created_at.to_json),
          "updated_at" => JSON.parse(thing.updated_at.to_json)
        }

        expect(body).to eq([expected_response])
      end
    end

    context "There are many things related to user" do
      it "Should return an array with all thing" do
        thing  = create(:thing)
        thing2 = create(:thing)
        thing3 = create(:thing)
        thing4 = create(:thing)
        Owner.create(from_node: user, to_node: thing)
        Owner.create(from_node: user, to_node: thing2)
        Owner.create(from_node: user, to_node: thing3)

        get '/api/v1/things', headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = [
          {
            "id" => thing.id,
            "name" => thing.name,
            "status" => thing.status,
            "pac" => thing.pac,
            "company_id" => thing.company_id,
            "units" => thing.units,
            "latitude" => thing.latitude,
            "longitude" => thing.longitude,
            "created_at" => JSON.parse(thing.created_at.to_json),
            "updated_at" => JSON.parse(thing.updated_at.to_json)
          }, {
            "id" => thing2.id,
            "name" => thing2.name,
            "status" => thing2.status,
            "pac" => thing2.pac,
            "company_id" => thing2.company_id,
            "units" => thing2.units,
            "latitude" => thing2.latitude,
            "longitude" => thing2.longitude,
            "created_at" => JSON.parse(thing2.created_at.to_json),
            "updated_at" => JSON.parse(thing2.updated_at.to_json)
          }, {
            "id" => thing3.id,
            "name" => thing3.name,
            "status" => thing3.status,
            "pac" => thing3.pac,
            "company_id" => thing3.company_id,
            "units" => thing3.units,
            "latitude" => thing3.latitude,
            "longitude" => thing3.longitude,
            "created_at" => JSON.parse(thing3.created_at.to_json),
            "updated_at" => JSON.parse(thing3.updated_at.to_json)
          }
        ]

        expect(body).to match_array(expected_response)
      end
    end
  end

  describe "GET/show things" do

    context "Access to a thing" do
      it "User owns the thing" do
        accumulator = create(:accumulator)
        Owner.create(from_node: user, to_node: accumulator.uplink.thing)

        get "/api/v1/things/#{accumulator.uplink.thing.name}", headers: header

        body = JSON.parse(response.body)
        thing = accumulator.uplink.thing

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response =
          {
            "id"=>thing.id,
            "name"=>thing.name,
            "new_alarms"=>false,
            "status"=>thing.status,
            "pac"=>thing.pac,
            "company_id"=>thing.company_id,
            "units"=>thing.units,
            "latitude" => thing.latitude,
            "longitude" => thing.longitude,
            "created_at"=>JSON.parse(thing.created_at.to_json),
            "updated_at"=>JSON.parse(thing.updated_at.to_json),
            "valve_transition"=>JSON.parse(ThingSerializer.new(thing).valve_transition.to_json),
            "last_uplink"=>JSON.parse(ThingSerializer.new(thing).last_uplink.to_json),
            "last_messages"=>JSON.parse(ThingSerializer.new(thing).last_messages.to_json)
          }


        expect(body).to eq(expected_response)

      end
    end

    # context "Access to a thing" do
    #   it "User doesn't have relation with the thing" do
    #     thing  = create(:thing)

    #     get "/api/v1/things/#{thing.name}", headers: header

    #     p body = JSON.parse(response.body)

    #     expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
    #     expect(response.status).to eq(403)
    #   end
    # end

    context "Access to a thing" do
      it "User doesn't have relation with the thing but has a owner relation with other thing" do
        thing2 = create(:thing)
        Owner.create(from_node: user, to_node: thing2)
        thing  = create(:thing)

        get "/api/v1/things/#{thing.name}", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(403)
      end
    end
  end

  describe "PUT/update/:thing" do

    context "update attributes of a thing" do
      it "User owns the thing" do
        accumulator = create(:accumulator)
        uplink = accumulator.uplink
        battery_level = create(:battery_level, uplink: uplink)
        thing = uplink.thing
        Owner.create(from_node: user, to_node: thing)

        params = {
          pac: "123456",
          company_id: 987654,
          latitude: 4.5,
          longitude: 74.6,
          name: "new_name",
          new_alarms: "false",
          status: "deactivated"
        }

        put "/api/v1/things/#{thing.name}", headers: header, params: params

        parsed_body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = {
          "id"=>thing.id,
          "name"=>"new_name",
          "new_alarms"=> false,
          "status"=>"deactivated",
          "pac"=>"123456",
          "company_id"=>"987654",
          "units"=>thing.units,
          "latitude" => 4.5,
          "longitude" => 74.6,
          "created_at"=>JSON.parse(thing.created_at.to_json),
          "updated_at"=>parsed_body["updated_at"],
          "valve_transition"=>JSON.parse(ThingSerializer.new(thing).valve_transition.to_json),
          "last_uplink"=>JSON.parse(ThingSerializer.new(thing).last_uplink.to_json),
          "last_messages"=>JSON.parse(ThingSerializer.new(thing).last_messages.to_json)
        }

        expect(parsed_body).to eq(expected_response)
      end
    end

    context "Update a thing" do
      it "User doesn't have relation with the thing" do
        thing = create(:thing)

        params = {
          pac: "123456",
          company_id: 987654,
          latitude: 4.5,
          longitude: 74.6,
          name: "new_name",
          status: "deactivated"
        }

        put "/api/v1/things/#{thing.name}", headers: header, params: params

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(403)
      end
    end

    context "Update a thing" do
      it "User doesn't have relation with the thing but has another relation with other thing" do
        thing2 = create(:thing)
        Owner.create(from_node: user, to_node: thing2)
        thing = create(:thing)

        params = {
          pac: "123456",
          company_id: 987654,
          latitude: 4.5,
          longitude: 74.6,
          name: "new_name",
          status: "deactivated"
        }

        put "/api/v1/things/#{thing.name}", headers: header, params: params

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(403)
      end
    end
  end
end
