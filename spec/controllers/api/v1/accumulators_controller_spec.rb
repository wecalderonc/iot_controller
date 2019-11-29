require 'rails_helper'
RSpec.describe Api::V1::AccumulatorsController, :type => :request do
  let(:user)              { create(:user) }
  let(:thing)             { create(:thing, units: { "liter": 200 }) }
  let(:uplink)            { create(:uplink, thing: thing) }
  let!(:accumulator)      { create(:accumulator, value: 'AA', uplink: uplink) }
  let!(:accumulator2)     { create(:accumulator, value: 'BB', uplink: uplink) }
  let!(:price)            { create(:price) }
  let(:header)            { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "GET/index accumulators" do

    context "There is one thing with their accumulators" do
      it "Should return an array with all accumulatots of a one thing" do
        Owner.create(from_node: user, to_node: thing)

        get "/api/v1/things/#{thing.name}/accumulators", headers: header
        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = [
          {
            "id" => accumulator.id,
            "value" => accumulator.value,
            "units_count" => 0.85,
            "final_price" => 850.0,
            "created_at" => JSON.parse(accumulator.created_at.to_json),
            "updated_at" => JSON.parse(accumulator.updated_at.to_json)
          }, {
            "id" => accumulator2.id,
            "value" => accumulator2.value,
            "units_count" => 0.94,
            "final_price" => 935.0,
            "created_at" => JSON.parse(accumulator2.created_at.to_json),
            "updated_at" => JSON.parse(accumulator2.updated_at.to_json)
          }
        ]
        expect(body).to match_array(expected_response)
      end
    end

    context "Thing name don't exist" do
      it "Should return a message thing does not exist" do
        Owner.create(from_node: user, to_node: thing)
        thing_name = accumulator.uplink.thing.name

        get "/api/v1/things/wrongname/accumulators", headers: header


        body = JSON.parse(response.body)

        expected_response = "The thing wrongname does not exist"
        expect(body["message"]).to eq(expected_response)
        expect(response.status).to eq(404)

      end
    end

    context "Thing has no associated accumulators" do
      it "Should return a message of accumulators not found" do
      Owner.create(from_node: user, to_node: thing)
      thing = create(:thing)

        get "/api/v1/things/#{thing.name}/accumulators", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expected_response = "The thing #{thing.name} does not have accumulators"
        expect(body["message"]).to eq(expected_response)
        expect(response.status).to eq(404)
      end
    end

    context "The authorization code is wrong" do
      it "Should return a 401 status" do
        header['Authorization'] = "dsfkjsdhfsdhf"

        get "/api/v1/things/#{thing.name}/accumulators", headers: header

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(401)

        body = JSON.parse(response.body)

        expected_response = "Access denied!. Token is missing."
        expect(body["message"]).to eq(expected_response)
      end
    end

    context "The user is not authorized" do
      it "Should return a 403 status" do

        get "/api/v1/things/#{thing.name}/accumulators", headers: header

        expect(response.headers["Content-Type"]).to eq("text/html; charset=utf-8")
        expect(response.status).to eq(403)

        body = JSON.parse(response.body)

        expected_response = "Access Denied: You are not authorized to access this page."
        expect(body["message"]).to eq(expected_response)
      end
    end
  end
end
