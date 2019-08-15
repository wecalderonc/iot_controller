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

    context "The user is finishing the confirmation email process" do
      it "Should return json with success message" do

        get "/api/v1/users/#{user.email}?subaction=confirm_email&token=#{user.verification_code}"

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response =
          {
            "message" => "Email Confirmed! Thanks!"
          }

        expect(response_body).to eq(expected_response)
      end
    end

    context "A user is finishing the confirmation email process with bad token" do
      it "Should return json with success message" do

        bad_token = "fffffff"
        get "/api/v1/users/#{user.email}?subaction=confirm_email&token=#{bad_token}"

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response =
          {
            "message"=>"Token expired or incorrect - User not found"
          }

        expect(response_body).to eq(expected_response)
      end
    end

    context "A user forgot the password and is requesting the password recovery process" do
      it "Should return json with success message" do

        expect_any_instance_of(UserMailer).to receive(:recovery_email).once
        get "/api/v1/users/#{user.email}?subaction=request_password_recovery"

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response =
          {
            "message"=>'Recovery Password Email Sended! Go to your inbox!'
          }

        expect(response_body).to eq(expected_response)
      end
    end

    context "A user without account is requesting the password recovery process" do
      it "Should return json with failure message" do

        bad_email = "bad_email@gmail.com"
        get "/api/v1/users/#{bad_email}?subaction=request_password_recovery"

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response = 'User not found'

        expect(response_body["message"]).to eq(expected_response)
      end
    end

  end

  describe "POST/create users" do
    let(:country) { create(:country, code_iso: 'CO') }

    context "Sign Up process success" do
      it "Should return json with new User created" do

        body =
          {
            "first_name"=> "new_user",
            "last_name" => "new_last",
            "email"=> "new_user@gmail.com",
            "country_code"=> country.code_iso,
            "password"=> "validpass",
            "phone"=> "3013632461",
            "gender"=> "male",
            "id_number"=> "123456",
            "id_type"=> "cc",
            "code_number"=>  "123456789",
            "admin"=> "true",
            "user_type"=> "administrator"
          }

        expect_any_instance_of(UserMailer).to receive(:confirmation_email).once

        post '/api/v1/users', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response =

        {
          "first_name"=> "new_user",
          "last_name" => "new_last",
          "email"=> "new_user@gmail.com"
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
            "country_code"=> country.code_iso,
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
            "country_code"=> country.code_iso,
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

  describe "PUT/update/:user" do

    context "right params" do
      let!(:user) { create(:user, password: 'validpassword') }
      let(:country) { create(:country, code_iso: 'CO') }

      it "should update attributes of a user" do

        body =
          {
            first_name: "Daniela",
            last_name: "Patiño",
            new_email: "unacosita123@gmail.com",
            country_code: country.code_iso,
            current_password: 'validpassword',
            password: "nuevopassword",
            password_confirmation: "nuevopassword"
          }

        expect_any_instance_of(UserMailer).to receive(:update_confirmation).once

        put "/api/v1/users/#{user.email}", headers: header, params: body

        response_body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = {
          "first_name" => "Daniela",
          "last_name" => "Patiño",
          "email" => "unacosita123@gmail.com"
        }


        expect(response_body).to include(expected_response)
        expect(user.country.code_iso).to eq('CO')
      end
    end

    context "wrong params" do
      it "should return an update error" do
        put "/api/v1/users/invalid_id", headers: header

        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)
        expect(body["errors"]).to eq("User not found")
      end
    end
  end

  describe "PUT/update password user" do

    context "Recover Password process success" do
      it "Should return json with success response" do

        body =
          {
            "current_password"=> user.password,
            "password" => "new_pass",
            "password_confirmation"=> "new_pass"
          }

        put "/api/v1/users/#{user.email}?subaction=forgot_password", headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response =

        {
          "first_name"=> user.first_name,
          "last_name" => user.last_name,
          "email"=> user.email,
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "Recover password process failure with wrong user and password not related" do
      it "Should return error message" do

        body =
          {
            "current_password"=> "wrong_current_password",
            "password" => "new_pass",
            "password_confirmation"=> "new_pass"
          }

        put "/api/v1/users/#{user.email}", headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response =

        {
          "errors" => "Invalid password"
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "Recover password process failure with new_password and new_password_confirmation mismatched" do
      it "Should return error message" do

        body =
          {
            "current_password"=> user.password,
            "password" => "new_pass",
            "password_confirmation"=> "new_pass_wrong"
          }

        put "/api/v1/users/#{user.email}", headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response =
          {
            "errors" => {"matched_passwords"=>["New password and password confirmation don't match"]}
          }

        expect(response_body).to eq(expected_response)
      end
    end
  end
end
