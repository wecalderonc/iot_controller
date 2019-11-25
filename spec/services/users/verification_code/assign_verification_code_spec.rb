require 'rails_helper'

Rspec.describe Users::VerificationCode::AssignVerificationCode do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:user)     { create(:user) }
    let(:input)    { { user: user } }

    context 'Assigned verification code' do
      it 'it return a user with a verification code' do
        user.update(verification_code: nil)

        expect(user.verification_code).to be(nil)

        user.reload

        expect(response).to be(user)
        expect(user.verification_code).to be(user.verification_code)
      end
    end
  end
end
