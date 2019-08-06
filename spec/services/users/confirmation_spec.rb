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

        expected_response =
          {
            :json => {:message=>"Email Confirmed! Thanks!"}, :status=>:ok
          }

        expect(response).to eq(expected_response)
      end

      it "doesn't exist in db" do
        params = {
          token: "456879"
        }

        response = described_class.verification_code(params)

        expected_response =
            {
              :json => {:errors=>"Token expired or incorrect - User not found"},
              :status => :not_found
            }

        expect(response).to eq(expected_response)
      end
    end
  end
end
