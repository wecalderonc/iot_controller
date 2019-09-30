require 'rails_helper'

RSpec.describe Locations::Execute do
  describe "#call" do
    let(:location)  { create(:location, :with_thing) }
    let(:input) { { thing_name: location.thing.name } }

    context "When a user is trying to get the location of a thing" do
      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expected_response = location.attributes

          expect(response).to be_success
          expect(response.success.attributes).to eq(expected_response)
        end
      end

    context "When the 'validation' operation fails with wrong type of input" do
      it "Should return a Failure response" do
        input[:thing_name] = 12345

        response = subject.(input)

        expected_response = {
          :thing_name => ["must be String"]
        }

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end

     context "When the 'validation' operation fails without thing_name in body" do

       it "Should return a Failure response" do
         input.delete(:thing_name)

         response = subject.(input)

         expected_response = {
           :thing_name => ["is missing"]
         }

         expect(response).to be_failure
         expect(response.failure[:message]).to eq(expected_response)
       end
     end

     context "When the 'get thing' operation fails" do

       it "Should return a Failure response" do
         input[:thing_name] = "wrong_thing_name"

         response = subject.(input)

         expected_response = "The thing wrong_thing_name does not exist"

         expect(response).to be_failure
         expect(response.failure[:message]).to eq(expected_response)
       end
     end

     context "When the 'get location' operation fails" do

       it "Should return a Failure response" do
         thing2 = create(:thing)
         input[:thing_name] = thing2.name

         response = subject.(input)

         expected_response = "The thing #{thing2.name} does not have location"

         expect(response).to be_failure
         expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
