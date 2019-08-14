require 'rails_helper'

RSpec.describe Users::UpdateCountry do
  describe '#call' do
    context 'updating user country' do
      let(:user)     { create(:user, email: "user@gmail.com") }
      let(:country)  { create(:country, code_iso: 'CO') }
      let(:response) { subject.(input) }

      let(:input) {
        {
          country_code: country.code_iso,
          user: user
        }
      }

      context 'invalid country' do
        it 'should return a Failure response' do
          input[:country_code] = "invalid_code"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq("Country not found")
        end
      end

      context 'valid country' do
        it 'should return a success response' do
          expect(response).to be_success

          user.reload

          expect(user.country.code_iso).to eq('CO')
        end
      end
    end
  end
end
