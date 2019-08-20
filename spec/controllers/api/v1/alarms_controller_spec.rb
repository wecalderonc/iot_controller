require 'rails_helper'

RSpec.describe Api::V1::AlarmsController, :type => :request do
  let(:alarm)  { create(:alarm) }
  let(:user)   { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "PUT/update alarm state" do

    context "The request is ok" do
      it "Should return a 200 status" do
        put "/api/v1/alarms/#{alarm.id}", headers: header

        expect(response.successful?).to be_truthy

        alarm.reload

        expect(alarm.viewed).to be_truthy
      end
    end

    context "The authorization code is wrong" do
      it "Should return a 401 status" do
        header['Authorization'] = "dsfkjsdhfsdhf"

        put "/api/v1/alarms/#{alarm.id}", headers: header

        expect(response.successful?).to be_falsey
        expect(response.status).to eq(401)

        alarm.reload

        expect(alarm.viewed).to be_falsey
      end
    end

    context "The URL is wrong" do
      it "Should return a bad URI error" do
        put "/api/v1/alarms/326478956743856fhdsj", headers: header

        parsed_response = JSON.parse(response.body)

        expected_response = "The alarm 326478956743856fhdsj does not exist"
        expect(parsed_response["message"]).to eq(expected_response)

      end
   end
end

  describe "GET/index alarms" do

    context "There is one thing with their alarms" do
      it "Should return an array with all alarms of a one thing" do
        thing = alarm.uplink.thing

        get "/api/v1/things/#{thing.id}/alarms", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = { 
          "id" => alarm.id,
          "value" => alarm.value,
          "created_at" => JSON.parse(alarm.created_at.to_json),
          "updated_at" => JSON.parse(alarm.updated_at.to_json),
          "viewed" => alarm.viewed,
          "date" => JSON.parse(alarm.date.to_json)
        }

        expect(body).to eq([expected_response])

      end
    end

    context "Thing id don't exist" do
      it "Should return a message of thing not found" do
        thing = alarm.uplink.thing

        get "/api/v1/things/c3712cec-8ccc-40b5-851a-f62b2375d987", headers: header


        parsed_response = JSON.parse(response.body)

        expected_response = "Couldn't find Thing with 'uuid'=\"c3712cec-8ccc-40b5-851a-f62b2375d987\""
        expect(parsed_response["message"]).to eq(expected_response)
        expect(response.status).to eq(404)

      end
    end

    context "Thing has no associated alarms" do
      it "Should return a message of alarms not found" do
        thing = create(:thing)

        get "/api/v1/things/#{thing.id}/alarms", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expetected_response = "Alarms not found"
        expect(response.status).to eq(404)
      end
    end
  end
end
