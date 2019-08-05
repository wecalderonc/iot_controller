require 'rails_helper'

RSpec.describe Users::Get do
  describe "#call" do
    let(:response) { subject.(input) }

    context "user exists" do
      let(:user) { create(:user) }
      let(:input) { { id: user.id, first_name: user.first_name } }

      it "should return success response" do
        expect(response).to be_success
        expect(response.success[:first_name]).to eq(user.first_name)
      end
    end

    context "user doesn't exists" do
      let(:input) { { id: "invalid_id", first_name: "Daniela" } }

      it "should return failure response" do
        expect(response).to be_failure
        expect(response.failure[:message]).to eq("The user Daniela does not exist")
      end
    end
  end
end
