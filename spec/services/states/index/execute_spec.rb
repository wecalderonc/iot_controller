require 'rails_helper'

RSpec.describe States::Index::Execute do
  describe '#call' do
    let(:colombia) { create(:country, code_iso: 'CO') }
    let!(:states)  { create_list :state, 2, country: colombia }
    let(:response) { subject.(input) }
    let(:input)    { { country_code: colombia.code_iso } }

    context "When all the operations are successfull" do
      it "Should return a Success response" do
        expect(response).to be_success
        expect(response.success.count).to match(2)
      end
    end

    context "When the 'validation' operation fails with wrong type of input" do
      it "Should return a Failure response" do
        input[:country_code] = 12345

        response = subject.(input)

        expected_response = {
          :country_code => ["must be String"]
        }

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end

    context "When the 'get country' operation fails" do

      it "Should return a Failure response" do
        input[:country_code] = "invalid_code_iso"

        expected_response = "Country not found"

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
        expect(response.failure[:code]).to eq(10104)
      end
    end
  end
end
