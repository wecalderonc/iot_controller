require 'rails_helper'

RSpec.describe Api::V1::BatteryLevelsController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id })} }
  let(:battery_level) { create(:battery_level, value: "0003")}
  let(:thing) { battery_level.uplink.thing }

  describe "GET/index battery levels" do

    context "User doesn't have related things" do
      it "Should return unauthorized_message" do

        params = {
          thing_name: thing.name
        }

        get '/api/v1/battery_levels', headers: header, params: params

        #The Content-Type is text/html because is the CanCan answer. In postman works and return json
        expect(response.headers["Content-Type"]).to eq("text/html; charset=utf-8")
        expect(response.status).to eq(403)

        body = JSON.parse(response.body)

        expected_response = "Access Denied: You are not authorized to access this page."
        expect(body["message"]).to eq(expected_response)
      end
    end

    context "The User owns the thing" do
      it "Should return an array with battery_levels" do
        Owner.create(from_node: user, to_node: thing)

        params = {
          thing_name: thing.name
        }

        get '/api/v1/battery_levels', headers: header, params: params

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = {
          "created_at"=>JSON.parse(battery_level.created_at.to_json),
          "digit"=>"3",
          "level_label"=>"middle-high",
          "updated_at"=>JSON.parse(battery_level.updated_at.to_json),
          "value"=>"0003"
        }

        expect(body).to eq([expected_response])
      end
    end

    context "The thing does not exist in db" do
      it "Should return a message error" do
        Owner.create(from_node: user, to_node: thing)

        params = {
          thing_name: "wrong_name"
        }

        get '/api/v1/battery_levels', headers: header, params: params

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        expected_response = {
          "errors" => "The thing wrong_name does not exist"
        }

        expect(body).to eq(expected_response)
      end
    end

    context "The thing_name param has errrs" do
      it "Should return a message error" do
        Owner.create(from_node: user, to_node: thing)

        params = {
          thingggg_name: "wrong_name"
        }

        get '/api/v1/battery_levels', headers: header, params: params

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        expected_response = {
          "errors" => {"thing_name"=>["is missing"]}
        }

        expect(body).to eq(expected_response)
      end
    end
  end
end
