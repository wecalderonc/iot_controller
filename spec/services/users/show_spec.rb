require 'rails_helper'

RSpec.describe Users::Show do
  describe "#user_show" do
    let!(:user) { create(:user, email: "test@gmail.com") }

    context "Search a user" do
      it "does exist in db" do
        params = {
          email: "test@gmail",
          format: "com"
        }

        response = described_class.find_user(params)

        expected_response =
          {
            :id => user.id,
            :email=> user.email,
            :name=> user.first_name,
          }

        expect(response).to be_success
        expect(response.success).to eq(user)
      end

      it "doesn't exist in db" do
        params = {
          email: "test2@gmail",
          format: "com"
        }

        response = described_class.find_user(params)

        expected_response = "User not found"


        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end
  end
end
