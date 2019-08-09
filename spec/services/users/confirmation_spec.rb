require 'rails_helper'

RSpec.describe Users::Confirmation do
  describe "#verification_code" do
    let(:user) { create(:user) }

    context "Search a user with verification_code" do
      it "does exist in db" do
        params = {
          token: user.verification_code
        }

        response = described_class.verification_code(params)
        expect(response).to be_success

        expected_response =
          {
            :message=>"Email Confirmed! Thanks!"
          }

        expect(response).to be_success
        expect(response.success).to eq(expected_response)
      end

      it "doesn't exist in db" do
        params = {
          token: "456879"
        }

        response = described_class.verification_code(params)
        expect(response).to be_failure

        expected_response = "Token expired or incorrect - User not found"

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end
  end
end
