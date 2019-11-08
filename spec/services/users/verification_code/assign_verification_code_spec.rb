require 'rails_helper'

Rspec.describe Users::VerificationCode::AssignVerificationCode do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:user) { create(:user) }
    let(:input) { { user: user } }

    context ' verification code' do
      it 'it return a success response' do
        expect(response).to be(user)
      end
    end

    context ' verification code is different' do
      it 'it return a success response' do
        user.verification_code = '1a2b3c4d5e6f'

        expect(response).to be(user)

        user.reload

        expect(user.verification_code).not_to be('1a2b3c4d5e6f')
      end
    end
  end
end
