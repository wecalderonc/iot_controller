require 'rails_helper'

RSpec.describe AuthenticationController, :type => :controller do

  describe "POST authenticate_user" do
    let (:user) { create(:user) }

    context "The User is authenticating" do
      context "The data is valid" do
        it "Should return a succesfull message" do

          valid_token = "eyJhbGciOiJIUzI1NiJ9.eyJhcGlfdXNlcl9pZCI6MywiZXhwIjoxNTMwOTUyMDMzfQ.MW1tzWpDQWrZWgepHMoaT4vDVL0nT7H3yb_tfNQjYk0"

          expect(JsonWebToken).to receive(:encode).and_return(valid_token)

          post :authenticate_user, params: { email: user.email, password: user.password }

          expected_response = {
            "auth_token": valid_token,
            "email": user.email
          }.to_json

          expect(response.content_type).to eq "application/json"
          expect(response.status).to eq 200
          expect(response.body).to eq expected_response
        end
      end

      context "The data is invalid: the email is wrong" do
        it "Should return an error message" do
          expect(JsonWebToken).to_not receive(:encode)

          post :authenticate_user, params: { email: "invalid@mail.co", password: user.password }

          expected_response = { errors: 'User not found' }

          expect(response.content_type).to eq "application/json"
          expect(response.status).to eq 401
          expect(response.body).to eq expected_response.to_json
        end
      end

      context "The data is invalid: the password is wrong" do
        it "Should return an error message" do
          expect(JsonWebToken).to_not receive(:encode)

          post :authenticate_user, params: { email: user.email, password: "Invalidpass*" }

          expected_response = { errors: 'Invalid Username/Password' }

          expect(response.content_type).to eq "application/json"
          expect(response.status).to eq 401
          expect(response.body).to eq expected_response.to_json
        end
      end

      context "The data is invalid: the params are empty" do
        it "Should return an error message" do
          expect(JsonWebToken).to_not receive(:encode)

          post :authenticate_user, params: { }

          expected_response = { errors: { password: ["is missing"] } }.to_json

          expect(response.content_type).to eq "application/json"
          expect(response.status).to eq 401
          expect(response.body).to eq expected_response
        end
      end
    end
  end
end
