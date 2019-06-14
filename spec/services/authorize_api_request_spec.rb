require 'rails_helper'

RSpec.describe AuthorizeApiRequest do

  describe '#call' do
    subject { described_class.new }
    let(:user) { create(:user) }
    let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }) } }

    context 'when valid request' do
      it 'returns user object' do
        response = subject.(header)

        expect(response.success).to eq(user)
      end
    end

    context 'when invalid request' do
      context 'when missing token in headers' do
        it 'should return authorization not found error' do
          response = subject.({})

          expect(JsonWebToken).to_not receive(:decode)
          expect(response).to be_failure
          expect(response.failure[:message]).to eq("Authorization not found in headers")
        end
      end

      context 'when invalid token in headers' do
        it 'should return invalid token error' do
          invalid_token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2VjOTk5QGdtYWlsLmNvbSIsImV4cCI6MTU2MzA0MDk3OX0.jSkrlae5l0L0XE-Aux0eoxuw5K938HKba4yeCUG5vZ"
          response = subject.({ 'Authorization' => invalid_token })

          expect(JsonWebToken).to_not receive(:decode)
          expect(response).to be_failure
          expect(response.failure[:message]).to eq("Signature verification raised")
        end
      end

      context 'when token is expired' do
        it 'should return invalid token error' do
          expired_token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMjMsImV4cCI6MTU2MDI4MDE2OH0.BtGhTTZcSvZPlIY10iAUp_2grOHfTHAfX_JYR3iKvPI"
          response = subject.({ 'Authorization' => expired_token })

          expect(JsonWebToken).to_not receive(:decode)
          expect(response).to be_failure
          expect(response.failure[:message]).to eq("Signature has expired")
        end
      end

      context 'fake token' do
        it 'handles JWT::DecodeError' do
          response = subject.({ 'Authorization' => "lloolol" })

          expect(response).to be_failure
          expect(response.failure[:message]).to eq("Not enough or too many segments")
        end
      end
    end
  end
end
