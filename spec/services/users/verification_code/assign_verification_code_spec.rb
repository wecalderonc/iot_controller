require 'rails_helper'

Rspec.describe Users::VerificationCode::AssignVerificationCode do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:user)     { create(:user) }
    let(:input)    { { user: user } }

    context 'The user can get a verification code' do
      it 'Should return a success response' do

        allow(SecureRandom).to receive(:hex).with(6).and_return('abcd1234')

        user.update(verification_code: nil)

        expect(user.verification_code).to be_nil

        subject.(input)

        user.reload

        expect(user.verification_code).to eq('abcd1234')
      end
    end
  end
end
