require 'rails_helper'

Rspec.describe Users::VerificationCode::AssignVerificationCode do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:user)     { create(:user, verification_code: nil) }

    let(:input)    { { user: user } }

    context 'Assigned verification code' do
      it 'it return a user with a verification code' do

        expect(response).to be(user)
        expect(user.verification_code).not_to be(nil)
      end
    end
  end
end
