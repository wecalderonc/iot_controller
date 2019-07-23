require 'rails_helper'

RSpec.describe Api::V1::ThingsController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }), 'HTTP_ACCEPT' => "application/json" } }

  describe "GET/index things" do

    context "User doesn't have related things" do
      it "Should return unauthorized_message" do
        get '/api/v1/things', headers: header

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(403)

        body = JSON.parse(response.body)

        expected_response = "Access Denied: You are not authorized to access this page."
        expect(body["message"]).to eq(expected_response)
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

        expected_response =
          {
            "id" => thing.id,
            "name" => thing.name,
            "status" => thing.status,
            "pac" => thing.pac,
            "company_id" => thing.company_id,
            "coordinates" => thing.coordinates,
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
            "coordinates" => thing.coordinates,
            "created_at" => JSON.parse(thing.created_at.to_json),
            "updated_at" => JSON.parse(thing.updated_at.to_json)
          }, {
            "id" => thing2.id,
            "name" => thing2.name,
            "status" => thing2.status,
            "pac" => thing2.pac,
            "company_id" => thing2.company_id,
            "coordinates" => thing2.coordinates,
            "created_at" => JSON.parse(thing2.created_at.to_json),
            "updated_at" => JSON.parse(thing2.updated_at.to_json)
          }, {
            "id" => thing3.id,
            "name" => thing3.name,
            "status" => thing3.status,
            "pac" => thing3.pac,
            "company_id" => thing3.company_id,
            "coordinates" => thing3.coordinates,
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

        get "/api/v1/things/#{accumulator.uplink.thing.id}", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response =
          {
            "id"=>accumulator.uplink.thing.id,
            "name"=>accumulator.uplink.thing.name,
            "status"=>accumulator.uplink.thing.status,
            "pac"=>accumulator.uplink.thing.pac,
            "company_id"=>accumulator.uplink.thing.company_id,
            "coordinates"=>accumulator.uplink.thing.coordinates,
            "created_at"=>JSON.parse(accumulator.uplink.thing.created_at.to_json),
            "updated_at"=>JSON.parse(accumulator.uplink.thing.updated_at.to_json),
            "last_uplink"=>JSON.parse(ThingSerializer.new(accumulator.uplink.thing).last_uplink.to_json),
            "last_messages"=>JSON.parse(ThingSerializer.new(accumulator.uplink.thing).last_messages.to_json)
          }


        expect(body).to eq(expected_response)

      end
    end

    context "Access to a thing" do
      it "User doesn't have relation with the thing" do
        thing  = create(:thing)
        id = thing.id

        get "/api/v1/things/#{id}", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(403)
      end
    end
  end
end
