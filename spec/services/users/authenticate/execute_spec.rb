require 'rails_helper'

RSpec.describe Users::Authenticate::Execute do
  describe "#call" do
    let(:response) { subject.(params) }
    let(:user) { create(:user) }
    let(:params) {
      {
        email: user.email,
        password: user.password
      }
    }

    context "The data is valid" do
      it "Should return a succesfull message" do

        valid_token = "eyJhbGciOiJIUzI1NiJ9.eyJhcGlfdXNlcl9pZCI6MywiZXhwIjoxNTMwOTUyMDMzfQ.MW1tzWpDQWrZWgepHMoaT4vDVL0nT7H3yb_tfNQjYk0"

        expect(JsonWebToken).to receive(:encode).and_return(valid_token)

        expected_response = {
          "auth_token": valid_token,
          "email": user.email
        }

        expect(response).to be_success
        expect(response.success).to eq expected_response
      end
    end

    context "The data is invalid: the email is wrong" do
      it "Should return a error message" do
        expect(JsonWebToken).to_not receive(:encode)

        params[:email] = "invalid@mail.co"

        expect(response).to be_failure
        expect(response.failure[:message]).to eq("User not found")
        expect(response.failure[:code]).to eq(10104)
      end
    end

    context "The data is invalid: the password is wrong" do
      it "Should return a error message" do
        expect(JsonWebToken).to_not receive(:encode)

        params[:password] = "Invalid123*"
        expected_response = {
          password: "Invalid Username/Password"
        }

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
        expect(response.failure[:code]).to eq(10105)
      end
    end

    context "The data is invalid: the params are empty" do
      let(:params) { {} }

      it "Should return a error message" do
        expect(JsonWebToken).to_not receive(:encode)

        expected_response = {:password=>["is missing"]}

        expect(response).to be_failure
        expect(response.failure[:message]).to match(expected_response)
        expect(response.failure[:extra][:code]).to eq(400)
      end
    end

    context "Invalid password format" do
      it "Should return a failure response" do
        expect(JsonWebToken).to_not receive(:encode)

        params[:password] = "invalidformat"
        expected_response = {:password=>["is in invalid format"]}

        expect(response).to be_failure
        expect(response.failure[:message]).to match(expected_response)
        expect(response.failure[:extra][:code]).to eq(400)
      end
    end
  end
end
