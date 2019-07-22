require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "GET/index users" do

    context "There are one user" do
      it "Should return an array with one user" do
        get '/api/v1/users', headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = {
          "first_name" => user.first_name,
          "last_name" => user.last_name,
          "email" => user.email
        }

        expect(body).to eq([expected_response])
      end
    end

    context "There are many users" do
      it "Should return an array with all users" do
        user2 = create(:user)
        user3 = create(:user)

        get '/api/v1/users', headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = [
          {
            "first_name" => user.first_name,
            "last_name" => user.last_name,
            "email" => user.email
          }, {
            "first_name" => user2.first_name,
            "last_name" => user2.last_name,
            "email" => user2.email
          }, {
            "first_name" => user3.first_name,
            "last_name" => user3.last_name,
            "email" => user3.email
          }
        ]

        expect(body).to match_array(expected_response)
      end
    end
  end
end
