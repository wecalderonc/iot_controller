require 'rails_helper'

RSpec.describe Users::Get do
  describe '#call' do
    let(:response) { subject.(input) }

    context 'user exists' do
      let!(:user) { create(:user, email: 'unusuario@gmail.com') }
      let(:input) { { email: 'unusuario@gmail', format: 'com' } }

      it 'should return success response' do
        expect(response).to be_success
        expect(response.success[:user]).to eq(user)
      end
    end

    context 'user does not exists' do
      let(:input) { { email: 'invalid_id', format: 'com' } }

      it 'should return failure response' do
        expect(response).to be_failure
        expect(response.failure[:message]).to eq('User not found')
      end
    end
  end
end
