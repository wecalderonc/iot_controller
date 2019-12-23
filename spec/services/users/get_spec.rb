require 'rails_helper'

RSpec.describe Users::Get do
  describe '#call' do
    let(:response) { subject.(input) }

    context 'user exists (email format separated)' do
      let!(:user) { create(:user, email: 'unusuario@gmail.com') }
      let(:input) { { email: 'unusuario@gmail.com'} }

      it 'should return success response' do
        expect(response).to be_success
        expect(response.success[:user]).to eq(user)
      end
    end

    context 'user does not exists (email format separated)' do
      let(:input) { { email: 'invalid_email', format: 'com' } }

      it 'should return failure response' do
        expect(response).to be_failure
        expect(response.failure[:message]).to eq('User not found')
        expect(response.failure[:error]).to eq('User not found')
        expect(response.failure[:code]).to eq('10104')
      end
    end

    context 'user exists' do
      let!(:user) { create(:user, email: 'unusuario@gmail.com') }
      let(:input) { { email: 'unusuario@gmail.com' } }

      it 'should return success response' do
        expect(response).to be_success
        expect(response.success[:user]).to eq(user)
      end
    end

    context 'user does not exists' do
      let(:input) { { email: 'invalid_id' } }

      it 'should return failure response' do
        expect(response).to be_failure
        expect(response.failure[:error]).to eq('User not found')
        expect(response.failure[:code]).to eq('10104')
      end
    end
  end
end
