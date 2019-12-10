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

  describe "GET/confirm_email " do
    context "The user is finishing the confirmation email process" do
      it "Should return json with success message" do
        params = { verification_code: user.verification_code }

        post "/confirm_email", params: params

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response = {
          "message" => "Email Confirmed! Thanks!"
        }

        user.reload

        expect(response_body).to eq(expected_response)
        expect(user.verification_code).to be_nil
      end
    end

    context "A user is finishing the confirmation email process with bad token" do
      it "Should return json with success message" do
        params = { verification_code: "not_exist" }

        post "/confirm_email", params: params

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(10104)

        response_body = JSON.parse(response.body)

        expected_response = "The user does not exist"

        expect(response_body["error"]).to eq(expected_response)
      end
    end

    context "A user is finishing the confirmation email without token" do
      it "Should return json with success message" do
        params = {}

        post "/confirm_email", params: params

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(10104)

        response_body = JSON.parse(response.body)

        expected_response = "The user does not exist"

        expect(response_body["error"]).to eq(expected_response)
      end
    end
  end

  describe "POST/request_password_recovery " do
    context "A user forgot the password and is requesting the password recovery process" do
      it "Should return json with success message" do

        expect_any_instance_of(UserMailer).to receive(:recovery_email).once

        params = {
          email: user.email
        }

        post "/request_password_recovery", params: params

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response = {
          "message"=>'Recovery Password Email Sent! Go to your inbox!'
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "A user without account is requesting the password recovery process" do
      it "Should return json with failure message" do

        params = { email: "bad_email@gmail.com" }

        post "/request_password_recovery", params: params

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(10104)

        response_body = JSON.parse(response.body)

        expected_response = 'User not found'

        expect(response_body["error"]).to eq(expected_response)
      end
    end
  end

  describe "POST/create users" do
    let(:country) { create(:country, code_iso: 'CO') }

    context "Sign Up process success" do
      it "Should return json with new User created" do

        body = {
          "first_name"=> "new_user",
          "last_name" => "new_last",
          "email"=> "new_user@gmail.com",
          "country_code"=> country.code_iso,
          "password"=> "Waico123*",
          "phone"=> "3013632461",
          "gender"=> "male",
          "id_number"=> "123456",
          "id_type"=> "cc",
          "admin"=> "false",
          "user_type"=> "administrator"
        }

        expect_any_instance_of(UserMailer).to receive(:confirmation_email).once

        post '/api/v1/users', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response = {
          "first_name"=> "new_user",
          "last_name" => "new_last",
          "email"=> "new_user@gmail.com"
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "Sign Up process failure" do
      it "Should return error message" do

        body = {
          "first_name"=> "new_user",
          "last_name" => "new_last",
          "email"=> user.email,
          "country_code"=> country.code_iso,
          "password"=> "validpass",
          "phone"=> "3013632461",
          "gender"=> "male",
          "id_number"=> "123456",
          "id_type"=> "cc",
          "user_type"=> "administrator",
          "admin"=> "true"
        }

        post '/api/v1/users', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response = {
          "errors" => {
            "password" => ["is in invalid format"],
            "uniq_email"=>["Email already exist"]
          }
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "Sign Up process failure with wrong email, gender and id_type" do
      it "Should return error message" do

        body = {
          "first_name"=> "name",
          "last_name" => "last_name",
          "email"=> 123456,
          "country_code"=> country.code_iso,
          "password"=> "123456",
          "phone"=> "12345689",
          "gender"=> 123456,
          "id_number"=> "123456",
          "id_type"=> 123456,
          "user_type"=> "administrator",
          "admin"=> "true"
        }

        post '/api/v1/users', headers: header, params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response = {
          "errors" => {
            "email"=>["is in invalid format"],
            "invalid_gender"=>["must be one of: male, female"],
            "invalid_id_type"=>["must be one of: cc, ce, natural_nit, bussines_nit, foreign_nit, passport, civil_register"],
            "password"=>["is in invalid format"]
          }
        }

        expect(response_body).to eq(expected_response)
      end
    end
  end

  describe "PUT/update/:user" do

    context "right params" do
      let!(:user) { create(:user, password: 'Validpassword*') }
      let(:country) { create(:country, code_iso: 'CO') }

      it "should update attributes of a user" do

        body = {
          first_name: "Daniela",
          last_name: "Patiño",
          new_email: "unacosita123@gmail.com",
          country_code: country.code_iso,
          current_password: 'Validpassword*',
          password: "Proci123*",
          password_confirmation: "Proci123*"
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
        put "/api/v1/users/invalid_id@proci.com", headers: header

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

        body = {
          "email"=> user.email,
          "current_password"=> user.password,
          "password" => "new_pass",
          "password_confirmation"=> "new_pass"
        }

        put "/change_forgotten_password", params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response = {
          "first_name"=> user.first_name,
          "last_name" => user.last_name,
          "email"=> user.email,
        }

        user.reload

        expect(user.password).to eq("new_pass")
        expect(response_body).to eq(expected_response)
      end
    end

    context "Recover password process failure with wrong user and password not related" do
      it "Should return error message" do

        body = {
          "email"=> user.email,
          "current_password"=> "wrong_current_password",
          "password" => "new_pass",
          "password_confirmation"=> "new_pass"
        }

        put "/change_forgotten_password", params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response = {
          "errors" => "Current Password is incorrect"
        }

        expect(response_body).to eq(expected_response)
      end
    end

    context "Recover password process failure with new_password and new_password_confirmation mismatched" do
      it "Should return error message" do

        body = {
          "email"=> user.email,
          "current_password"=> user.password,
          "password" => "new_pass",
          "password_confirmation"=> "new_pass_wrong"
        }

        put "/change_forgotten_password", params: body

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response = {
          "errors" => {"same_password"=>["The new password doesn't match with the confirmation"]}
        }

        expect(response_body).to eq(expected_response)
      end
    end
  end

  describe "PUT/update verification code" do

    context "Assign new verification code" do
      it "Should return json with success response" do
        expect_any_instance_of(UserMailer).to receive(:update_confirmation).once
        user.verification_code = nil

        params = {
          "subaction"=> "assign_code"
        }

        put "/api/v1/users/#{user.email}", headers: header, params: params

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expected_response = {
          "first_name"=> user.first_name,
          "last_name" => user.last_name,
          "email"=> user.email,
        }

        user.reload

        expect(user.verification_code).not_to be(nil)
        expect(response_body).to eq(expected_response)
      end
    end

    context "Wrong user email" do
      it "Should return error message" do

        params = {
          "subaction"=> "assign_code"
        }

        put "/api/v1/users/fulanito@guayando.com", headers: header, params: params

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        response_body = JSON.parse(response.body)

        expected_response = {
          "errors" => "User not found"
        }

        expect(response_body).to eq(expected_response)
      end
    end
  end
end
