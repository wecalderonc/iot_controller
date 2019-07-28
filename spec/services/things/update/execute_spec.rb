require 'rails_helper'

RSpec.describe Things::Update::Execute do
  describe "#call" do
    context "When the user is updating thing params" do
      let(:accumulator) { create(:accumulator) }
      let(:input)       {
        { thing_name: accumulator.uplink.thing.name,
          id: accumulator.uplink.thing.id,
          params: {
            pac: "123456",
            company_id: 987654,
            latitude: 4.5,
            longitude: 74.6,
            name: "new_name",
            status: "deactivated"
          }
        }
      }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success.name).to match("new_name")
          expect(response.success.status).to match("deactivated")
          expect(response.success.longitude).to match(74.6)
          expect(response.success.latitude).to match(4.5)
          expect(response.success.company_id).to match("987654")
          expect(response.success.pac).to match("123456")
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:params][:pac] = 12345

          response = subject.(input)
          expected_response = {
            :pac => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:params][:company_id] = "12345"

          response = subject.(input)
          expected_response = {
            :company_id => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:params][:name] = 123456

          response = subject.(input)
          expected_response = {
            :name => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:params][:status] = 12345

          response = subject.(input)
          expected_response = {
            :status => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:params][:longitude] = "12345"

          response = subject.(input)
          expected_response = {
            :longitude => ["must be Float"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:params][:latitude] = "12345"

          response = subject.(input)
          expected_response = {
            :latitude => ["must be Float"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'get' operation fails" do
        it "Should return a Failure response" do
          input.delete(:thing_name)

          response = subject.(input)
          expected_response = "The thing  does not exist"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
