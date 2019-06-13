require 'rails_helper'

RSpec.describe AuthenticateUser do
  describe "#call" do
    subject { described_class.new }
    let (:user) { create(:user) }

    after(:all) do
      User.where(email: "valid@mail.co").each(&:destroy)
    end

    context "The data is valid" do
      it "Should return a succesfull message" do

        valid_token = "eyJhbGciOiJIUzI1NiJ9.eyJhcGlfdXNlcl9pZCI6MywiZXhwIjoxNTMwOTUyMDMzfQ.MW1tzWpDQWrZWgepHMoaT4vDVL0nT7H3yb_tfNQjYk0"

        expect(JsonWebToken).to receive(:encode).and_return(valid_token)

        params = { email: user.email, password: user.password }
        response = subject.(params)

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

        params = { email: "invalid@mail.co", password: user.password }
        response = subject.(params)

        expect(response).to be_failure
        expect(response.failure[:message]).to eq("User not found")
      end
    end

    context "The data is invalid: the password is wrong" do
      it "Should return a error message" do
        expect(JsonWebToken).to_not receive(:encode)

        params = { email: user.email, password: "invalidpass" }
        response = subject.(params)

        expect(response).to be_failure
        expect(response.failure[:message]).to eq("Invalid Username/Password")
      end
    end

    context "The data is invalid: the params are empty" do
      it "Should return a error message" do
        expect(JsonWebToken).to_not receive(:encode)

        response = subject.({})

        expect(response).to be_failure
        expect(response.failure[:message]).to eq("User not found")
      end
    end
  end
end
