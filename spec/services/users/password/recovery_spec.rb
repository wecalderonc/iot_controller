require 'rails_helper'

RSpec.describe Users::Password::Recovery do
  describe "#call" do
    let!(:user) { create(:user, email: "test@gmail.com") }
    let(:response) { subject.(params) }

    context "Search a user email" do
      let(:params) { { email: 'test@gmail.com' } }

      it "should return success and send email" do
        expected_response = { message: "Recovery Password Email Sent! Go to your inbox!" }

        expect(response).to be_success
        expect(response.success).to eq(expected_response)
      end
    end

    context "Search a invalid email" do
      let(:params) { { email: "test2@gmail.com" } }

      it "that doesn't exist in db" do
        expected_response = "User not found"

        expect(response).to be_failure
        expect(response.failure[:error]).to eq(expected_response)
      end
    end
  end
end
