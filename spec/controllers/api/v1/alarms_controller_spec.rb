require 'rails_helper'
RSpec.describe Api::V1::AlarmsController, :type => :request do
  let(:user)   { create(:user) }
  let(:alarm)  { create(:alarm) }
  let(:thing)  { alarm.uplink.thing }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "PUT/update alarm state" do

    context "The request is ok" do
      it "Should return a 200 status" do
        Owner.create(from_node: user, to_node: thing)
        thing_name = alarm.uplink.thing.name

        put "/api/v1/things/#{thing_name}/alarms/#{alarm.id}", headers: header

        expect(response.successful?).to be_truthy

        alarm.reload

        expect(alarm.viewed).to be_truthy
        expect(response.status).to eq(200)
      end
    end

    context "The authorization code is wrong" do
      it "Should return a 401 status" do
        header['Authorization'] = "dsfkjsdhfsdhf"
        thing_name = alarm.uplink.thing.name

        put "/api/v1/things/#{thing_name}/alarms/#{alarm.id}", headers: header

        expect(response.successful?).to be_falsey
        expect(response.status).to eq(401)

        alarm.reload

        expect(alarm.viewed).to be_falsey
      end
    end

    context "The URL is wrong" do
      it "Should return a bad URI error" do
        thing_name = alarm.uplink.thing.name

        put "/api/v1/things/#{thing_name}/alarms/326478956743856fhdsj", headers: header

        parsed_response = JSON.parse(response.body)

        expected_response = "Couldn't find Alarm with 'uuid'=\"326478956743856fhdsj\""
        expect(parsed_response["message"]).to eq(expected_response)

      end
   end
end

  describe "GET/index alarms" do

    context "There is one thing with their alarms" do
      it "Should return an array with all alarms of a one thing" do
       Owner.create(from_node: user, to_node: thing)
       thing_name = alarm.uplink.thing.name

        get "/api/v1/things/#{thing_name}/alarms", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = {
          "id" => alarm.id,
          "value" => alarm.value,
          "created_at" => JSON.parse(alarm.created_at.to_json),
          "updated_at" => JSON.parse(alarm.updated_at.to_json),
          "viewed" => alarm.viewed,
          "viewed_date" => JSON.parse(alarm.viewed_date.to_json)
        }

        expect(body).to eq([expected_response])

      end
    end

    context "Thing name don't exist" do
      it "Should return a message thing does not exist" do
        Owner.create(from_node: user, to_node: thing)
        thing_name = alarm.uplink.thing.name

        get "/api/v1/things/wrongname/alarms", headers: header


        parsed_response = JSON.parse(response.body)

        expected_response = "The thing wrongname does not exist"
        expect(parsed_response["message"]).to eq(expected_response)
        expect(response.status).to eq(404)

      end
    end

    context "Thing has no associated alarms" do
      it "Should return a message of alarms not found" do
      Owner.create(from_node: user, to_node: thing)
      thing = create(:thing)

        get "/api/v1/things/#{thing.name}/alarms", headers: header

        parsed_response = JSON.parse(response.body)

        expected_response = "The thing #{thing.name} does not have alarms"
        expect(parsed_response["message"]).to eq(expected_response)
        expect(response.status).to eq(404)
      end
    end
  end
end
