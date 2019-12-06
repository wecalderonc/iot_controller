require 'rails_helper'

RSpec.describe Users::Confirm do
  describe "#call" do
    let(:user) { create(:user) }

    context "Search a user with verification_code" do
      it "does exist in db" do
        response = subject.(user.verification_code)

        expect(response).to be_success

        expected_response = "Email Confirmed! Thanks!"

        expect(response.success[:message]).to eq(expected_response)
      end

      it "doesn't exist in db" do
        verification_code =  "not_exist"

        response = subject.(verification_code)

        expect(response).to be_failure

        expected_response = "The user does not exist"

        expect(response.failure[:error]).to eq(expected_response)
        expect(response.failure[:code]).to eq("10104")
      end
    end
  end
end
