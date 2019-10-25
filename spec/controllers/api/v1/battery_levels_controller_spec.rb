require 'rails_helper'

RSpec.describe Api::V1::BatteryLevelsController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id })} }
  let(:battery_level) { create(:battery_level, value: "0003", created_at: DateTime.new(2019,9,30))}
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
      context "upward transition nearest than last power connection alarm" do
        it "Should return an array with battery_levels" do
          Owner.create(from_node: user, to_node: thing)
          uplink = create(:uplink, thing: thing)
          uplink2 = create(:uplink, thing: thing)
          uplink3 = create(:uplink, thing: thing)
          uplink4 = create(:uplink, thing: thing)
          uplink5 = create(:uplink, thing: thing)
          uplink6 = create(:uplink, thing: thing)

          alarm = create(:alarm, value: "0001", created_at: DateTime.new(2019,10,1), uplink: uplink)
          battery_level1 = create(:battery_level, value: "0005", uplink: uplink, created_at: DateTime.new(2019,10,1))
          battery_level2 = create(:battery_level, value: "0004", uplink: uplink2, created_at: DateTime.new(2019,10,2))
          battery_level3 = create(:battery_level, value: "0005", uplink: uplink3, created_at: DateTime.new(2019,10,3))
          battery_level4 = create(:battery_level, value: "0003", uplink: uplink4, created_at: DateTime.new(2019,10,4))
          battery_level5 = create(:battery_level, value: "0004", uplink: uplink5, created_at: DateTime.new(2019,10,5))
          battery_level6 = create(:battery_level, value: "0001", uplink: uplink6, created_at: DateTime.new(2019,10,6))

          get "/api/v1/things/#{thing.name}/battery_levels?subaction=graphic", headers: header

          body = JSON.parse(response.body)

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)

          expected_response = [
            {
              "id"=>battery_level5.id,
              "created_at"=>JSON.parse(battery_level5.created_at.to_json),
              "level_label"=>"high",
              "updated_at"=>JSON.parse(battery_level5.updated_at.to_json),
              "value"=>"0004"
            },
            {
              "id"=>battery_level6.id,
              "created_at"=>JSON.parse(battery_level6.created_at.to_json),
              "level_label"=>"low",
              "updated_at"=>JSON.parse(battery_level6.updated_at.to_json),
              "value"=>"0001"
            }
          ]

          expect(body).to eq(expected_response)
        end
      end

      context "last power connection alarm nearest than upward transition" do
        it "Should return an array with battery_levels" do
          Owner.create(from_node: user, to_node: thing)
          uplink = create(:uplink, thing: thing)
          uplink2 = create(:uplink, thing: thing)
          uplink3 = create(:uplink, thing: thing)
          uplink4 = create(:uplink, thing: thing)
          uplink5 = create(:uplink, thing: thing)
          uplink6 = create(:uplink, thing: thing)

          alarm = create(:alarm, value: "0001", created_at: DateTime.new(2019,10,3), uplink: uplink)
          battery_level1 = create(:battery_level, value: "0004", uplink: uplink, created_at: DateTime.new(2019,10,1))
          battery_level2 = create(:battery_level, value: "0005", uplink: uplink2, created_at: DateTime.new(2019,10,2))
          battery_level3 = create(:battery_level, value: "0004", uplink: uplink3, created_at: DateTime.new(2019,10,3))
          battery_level4 = create(:battery_level, value: "0003", uplink: uplink4, created_at: DateTime.new(2019,10,4))
          battery_level5 = create(:battery_level, value: "0002", uplink: uplink5, created_at: DateTime.new(2019,10,5))
          battery_level6 = create(:battery_level, value: "0001", uplink: uplink6, created_at: DateTime.new(2019,10,6))

          get "/api/v1/things/#{thing.name}/battery_levels?subaction=graphic", headers: header

          body = JSON.parse(response.body)

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)

          expected_response = [
            {
              "id"=>battery_level4.id,
              "created_at"=>JSON.parse(battery_level4.created_at.to_json),
              "level_label"=>"middle_high",
              "updated_at"=>JSON.parse(battery_level4.updated_at.to_json),
              "value"=>"0003"
            },
            {
              "id"=>battery_level5.id,
              "created_at"=>JSON.parse(battery_level5.created_at.to_json),
              "level_label"=>"middle_low",
              "updated_at"=>JSON.parse(battery_level5.updated_at.to_json),
              "value"=>"0002"
            },
            {
              "id"=>battery_level6.id,
              "created_at"=>JSON.parse(battery_level6.created_at.to_json),
              "level_label"=>"low",
              "updated_at"=>JSON.parse(battery_level6.updated_at.to_json),
              "value"=>"0001"
            }
          ]

          expect(body).to eq(expected_response)
        end
      end

      context "the thing has last power connection alarm but no upward transition" do
        it "Should return an array with battery_levels" do
          Owner.create(from_node: user, to_node: thing)
          uplink = create(:uplink, thing: thing)
          uplink2 = create(:uplink, thing: thing)

          alarm = create(:alarm, value: "0001", created_at: DateTime.new(2019,9,29), uplink: uplink)
          battery_level1 = create(:battery_level, value: "0002", uplink: uplink, created_at: DateTime.new(2019,10,1))
          battery_level2 = create(:battery_level, value: "0001", uplink: uplink2, created_at: DateTime.new(2019,10,2))

          get "/api/v1/things/#{thing.name}/battery_levels?subaction=graphic", headers: header

          body = JSON.parse(response.body)

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)

          expected_response = [
            {
              "id"=>battery_level.id,
              "created_at"=>JSON.parse(battery_level.created_at.to_json),
              "level_label"=>"middle_high",
              "updated_at"=>JSON.parse(battery_level.updated_at.to_json),
              "value"=>"0003"
            },
            {
              "id"=>battery_level1.id,
              "created_at"=>JSON.parse(battery_level1.created_at.to_json),
              "level_label"=>"middle_low",
              "updated_at"=>JSON.parse(battery_level1.updated_at.to_json),
              "value"=>"0002"
            },
            {
              "id"=>battery_level2.id,
              "created_at"=>JSON.parse(battery_level2.created_at.to_json),
              "level_label"=>"low",
              "updated_at"=>JSON.parse(battery_level2.updated_at.to_json),
              "value"=>"0001"
            }
          ]

          expect(body).to eq(expected_response)
        end
      end

      context "the thing has upward_transition but last power connection alarm" do
        it "Should return an battery levels" do
          Owner.create(from_node: user, to_node: thing)
          uplink = create(:uplink, thing: thing)
          uplink2 = create(:uplink, thing: thing)
          uplink3 = create(:uplink, thing: thing)

          battery_level1 = create(:battery_level, value: "0002", uplink: uplink, created_at: DateTime.new(2019,10,1))
          battery_level2 = create(:battery_level, value: "0004", uplink: uplink2, created_at: DateTime.new(2019,10,2))
          battery_level3 = create(:battery_level, value: "0003", uplink: uplink, created_at: DateTime.new(2019,10,3))

          get "/api/v1/things/#{thing.name}/battery_levels?subaction=graphic", headers: header

          body = JSON.parse(response.body)

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)

          expected_response = [
            {
              "id"=>battery_level2.id,
              "created_at"=>JSON.parse(battery_level2.created_at.to_json),
              "level_label"=>"high",
              "updated_at"=>JSON.parse(battery_level2.updated_at.to_json),
              "value"=>"0004"
            },
            {
              "id"=>battery_level3.id,
              "created_at"=>JSON.parse(battery_level3.created_at.to_json),
              "level_label"=>"middle_high",
              "updated_at"=>JSON.parse(battery_level3.updated_at.to_json),
              "value"=>"0003"
            }
          ]

          expect(body).to eq(expected_response)
        end
      end

      context "the thing does not have upward_transition and does not have last power connection alarm" do
        it "Should return battery levels" do
          Owner.create(from_node: user, to_node: thing)
          uplink = create(:uplink, thing: thing)
          uplink2 = create(:uplink, thing: thing)
          uplink3 = create(:uplink, thing: thing)

          battery_level1 = create(:battery_level, value: "0002", uplink: uplink, created_at: DateTime.new(2019,10,1))
          battery_level2 = create(:battery_level, value: "0001", uplink: uplink2, created_at: DateTime.new(2019,10,2))

          get "/api/v1/things/#{thing.name}/battery_levels?subaction=graphic", headers: header

          body = JSON.parse(response.body)

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(200)

          expected_response = [
            {
              "id"=>battery_level.id,
              "created_at"=>JSON.parse(battery_level.created_at.to_json),
              "level_label"=>"middle_high",
              "updated_at"=>JSON.parse(battery_level.updated_at.to_json),
              "value"=>"0003"
            },
            {
              "id"=>battery_level1.id,
              "created_at"=>JSON.parse(battery_level1.created_at.to_json),
              "level_label"=>"middle_low",
              "updated_at"=>JSON.parse(battery_level1.updated_at.to_json),
              "value"=>"0002"
            },
            {
              "id"=>battery_level2.id,
              "created_at"=>JSON.parse(battery_level2.created_at.to_json),
              "level_label"=>"low",
              "updated_at"=>JSON.parse(battery_level2.updated_at.to_json),
              "value"=>"0001"
            }
          ]

          expect(body).to eq(expected_response)
        end
      end

      context "the thing does not battery levels" do
        it "Should return an error message" do
          thing2 = create(:thing)
          Owner.create(from_node: user, to_node: thing2)
          get "/api/v1/things/#{thing2.name}/battery_levels?subaction=graphic", headers: header

          body = JSON.parse(response.body)

          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
          expect(response.status).to eq(404)

          expected_response = "The thing #{thing2.name} does not have battery level history"

          expect(body["errors"]).to eq(expected_response)
        end
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
