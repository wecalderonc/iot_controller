require 'rails_helper'

RSpec.describe Users::Show do
  describe "#user_show" do
    let!(:user) { create(:user, email: "test@gmail.com") }

    context "Search a user" do
      it "does exist in db" do
        params = {
          "email" => "test@gmail",
          format: "com"
        }

        response = described_class.user_show(params)

        expected_response =
          {
            :json =>
              {
                :id => user.id,
                :email=> user.email,
                :name=> user.first_name
              },
            :status=>:ok
          }

        expect(response).to eq(expected_response)
      end

      it "doesn't exist in db" do
        params = {
          "email" => "test2@gmail",
          format: "com"
        }

        response = described_class.user_show(params)

        expected_response =
            {
              :json => {:errors=>"user not found"},
              :status => :not_found
            }

        expect(response).to eq(expected_response)
      end
    end
  end
end
