require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

  describe "GET/index users" do
    before(:each) do
      User.all.each { |user| user.destroy }
    end

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

  describe "POST/create users" do

    context "Sign Up process success" do
      it "Should return json with new User created" do

        body =
          {
            "first_name"=> "new_user",
            "last_name" => "new_last",
            "email"=> "new_user@gmail.com",
            "password"=> "validpass",
            "phone"=> "3013632461",
            "gender"=> "male",
            "id_number"=> "123456",
            "id_type"=> "cc",
            "code_number"=>  "123456789",
            "admin"=> "true",
            "user_type"=> "administrator"
          }

        post '/api/v1/users', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response =

        {
          "first_name"=> "new_user",
          "last_name" => "new_last",
          "email"=> "new_user@gmail.com",
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "Sign Up process failure" do
      it "Should return error message" do

        body =
          {
            "first_name"=> "new_user",
            "last_name" => "new_last",
            "email"=> user.email,
            "password"=> "validpass",
            "phone"=> "3013632461",
            "gender"=> "male",
            "id_number"=> "123456",
            "id_type"=> "cc",
            "code_number"=> user.code_number,
            "user_type"=> "administrator",
            "admin"=> "true"
          }

        post '/api/v1/users', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response =

        {
          "errors" => {
            "uniq_code_number"=>["Code number already exist"],
            "uniq_email"=>["Email already exist"]
          }
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "Sign Up process failure with wrong email, gender and id_type" do
      it "Should return error message" do

        body =
          {
            "first_name"=> "name",
            "last_name" => "last_name",
            "email"=> 123456,
            "password"=> "123456",
            "phone"=> "12345689",
            "gender"=> 123456,
            "id_number"=> "123456",
            "id_type"=> 123456,
            "code_number"=> "123456",
            "user_type"=> "administrator",
            "admin"=> "true"
          }

        post '/api/v1/users', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response =

        {
          "errors" => {
            "email"=>["is in invalid format"],
            "gender"=>["must be one of: male, female"],
            "id_type"=>["must be one of: cc, ce, natural_nit, bussines_nit, foreign_nit, passport, civil_register"]
          }
        }

        expect(response_body).to eq(expected_response)
      end
    end
  end
end
