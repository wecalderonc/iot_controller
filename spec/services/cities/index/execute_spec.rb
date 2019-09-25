require 'rails_helper'

RSpec.describe Cities::Index::Execute do
  describe '#call' do
    let(:antioquia) { create(:state, code_iso: 'ANT') }
    let!(:cities)   { create_list :city, 2, state: antioquia }
    let(:response) { subject.(input) }
    let(:input)    { { state_code: antioquia.code_iso } }

    context "When all the operations are successfull" do
      it "Should return a Success response" do
        expect(response).to be_success
        expect(response.success.count).to match(2)
      end
    end

    context "When the 'validation' operation fails with wrong type of input" do
      it "Should return a Failure response" do
        input[:state_code] = 12345

        response = subject.(input)

        expected_response = {
          :state_code => ["must be String"]
        }

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end

    context "When the 'get country' operation fails" do

      it "Should return a Failure response" do
        input[:state_code] = "invalid_code_iso"

        expected_response = "State not found"

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
        expect(response.failure[:code]).to eq(10104)
      end
    end
  end
end
