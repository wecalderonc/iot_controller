require 'rails_helper'

RSpec.describe Users::Update::ValidatePassword do
  describe "#call" do
    let(:response) { subject.(input) }
    let(:user) { create(:user) }
    let(:input) {
      { current_password: user.password,
        password: 'newpassword',
        password_confirmation: 'newpassword',
        user: user
      }
    }

    context 'invalid current password' do
      it 'should return a failure response' do
        input[:current_password] = 'invalidpassword'

        expect(response).to be_failure
        expect(response.failure[:message]).to eq("Invalid password")
      end
    end

    context 'valid current password' do
      it 'should return a success response' do

        expect(response).to be_success
        expect(response.success).not_to include(:current_password)
        expect(response.success).to include(:password)
        expect(response.success).to include(:password_confirmation)
      end
    end
  end
end
