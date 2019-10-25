require 'rails_helper'

RSpec.describe Api::V1::BatteryLevelsController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id })} }
  let(:battery_level) { create(:battery_level, value: "0003")}
  let(:thing) { battery_level.uplink.thing }

  describe "GET/index battery levels" do

    context "User doesn't have related things" do
      it "Should return unauthorized_message" do

        get "/api/v1/things/#{thing.name}/battery_levels", headers: header

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

        get "/api/v1/things/#{thing.name}/battery_levels", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = {
          "created_at"=>JSON.parse(battery_level.created_at.to_json),
          "digit"=>3,
          "level_label"=>"middle_high",
          "updated_at"=>JSON.parse(battery_level.updated_at.to_json),
          "value"=>"0003"
        }

        expect(body).to eq([expected_response])
      end
    end

    context "The thing_name param has errors" do
      it "Should return a message error" do
        Owner.create(from_node: user, to_node: thing)

        wrong_name = "wrong_name"
        get "/api/v1/things/#{wrong_name}/battery_levels", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        expected_response = {
          "errors" => "The thing wrong_name does not exist"
        }

        expect(body).to eq(expected_response)
      end
    end
  end

  describe "GET/index battery levels with GRAPHIC subaction" do

    context "User doesn't have related things" do
      it "Should return unauthorized_message" do

        get "/api/v1/things/#{thing.name}/battery_levels?subaction=graphic", headers: header

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

        get "/api/v1/things/#{thing.name}/battery_levels?subaction=graphic", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = {
          "created_at"=>JSON.parse(battery_level.created_at.to_json),
          "digit"=>3,
          "level_label"=>"middle_high",
          "updated_at"=>JSON.parse(battery_level.updated_at.to_json),
          "value"=>"0003"
        }

        expect(body).to eq([expected_response])
      end
    end

    context "The thing_name param has errors" do
      it "Should return a message error" do
        Owner.create(from_node: user, to_node: thing)

        wrong_name = "wrong_name"
        get "/api/v1/things/#{wrong_name}/battery_levels?subaction=graphic", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        expected_response = {
          "errors" => "The thing wrong_name does not exist"
        }

        expect(body).to eq(expected_response)
      end
    end
  end
end
