require 'rails_helper'

RSpec.describe Things::Accumulators::Index::Execute do
  describe "#call" do
    let(:accumulator) { create(:accumulator) }
    let(:thing) { accumulator.uplink.thing }
    let(:uplink2) { create(:uplink, thing: thing) }
    let!(:accumulator2) { create(:accumulator, uplink: uplink2) }

    context "When a user is trying to get all the accumulators from a thing" do
      let(:input) {
        {
          thing_name: accumulator.uplink.thing.name
        }
      }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success.count).to match(2)
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

    context "When the 'get accumulators' operation fails" do

      it "Should return a Failure response" do
        thing3 = create(:thing)
        input[:thing_name] = thing3.name

        response = subject.(input)

        expected_response = "The thing #{thing3.name} does not have accumulators"

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
