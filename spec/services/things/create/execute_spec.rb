require 'rails_helper'

RSpec.describe Things::Create::Execute do
  describe "#call" do
    context "creating new device" do
      let(:input) {
        {
          name: "thing_name_test",
          pac: "pac",
          company_id: 123456,
          latitude: 18.4,
          longitude: 4.7,
          status: "activated"
        }
      }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success.name).to match("thing_name_test")
          expect(response.success.pac).to match("pac")
          expect(response.success.company_id).to match("123456")
          expect(response.success.latitude).to match(18.4)
          expect(response.success.longitude).to match(4.7)
          expect(response.success.status).to match("activated")
        end
      end

      context "When the 'validation' operation fails with wrong type of inputs" do
        it "Should return a Failure response" do
          input[:name] = 12345
          input[:pac] = 12345
          input[:status] = 12345
          input[:latitude] = 12345
          input[:longitude] = 12345
          input[:company_id] = 12345.to_s

          response = subject.(input)

          expected_response = {
            :name => ["must be String"],
            :pac => ["must be String"],
            :status => ["must be String"],
            :latitude => ["must be Float"],
            :longitude => ["must be Float"],
            :company_id => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails with duplicate name" do
        let(:thing) { create(:thing) }

        it "Should return a Failure response" do
          input[:name] = thing.name
          input[:pac] = "pac"
          input[:status] = "activated"
          input[:latitude] = 18.4
          input[:longitude] = 4.7
          input[:company_id] = 123456

          response = subject.(input)

          expected_response = {
            :name => ["has already been taken"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
