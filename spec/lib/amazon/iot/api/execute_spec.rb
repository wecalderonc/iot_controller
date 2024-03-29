require 'rails_helper'

RSpec.describe Amazon::Iot::Api::Execute do
  describe "#call" do
    let(:thing) { create(:thing, name: '2BEE81') }
    let(:type)  { :reported }
    let(:input) { { thing_name: thing.name, type: type } }

    context "When all the operations are successful" do
      it "Should return a Success response" do
        VCR.use_cassette("aws_request_api_success") do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success[:data]).to be_a Hash
          expect(response.success[:data]["state"]["reported"]["data"]).to be_a String
          expect(response.success[:data]["state"]["reported"]["device"]).to match("2BEE81")
        end
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input.delete(:thing_name)

        response = subject.(input)

        expect(response).to be_failure
        expect(response.failure[:message]).to eq({:thing_name=>["is missing"]})
      end
    end

    context "When the 'request data' operation fails" do
      it "Should return a Failure response" do
        VCR.use_cassette("aws_thing_not_exist") do
          input[:thing_name] = "XXxx"

          response = subject.(input)

          expect(response).to be_failure
          expect(response.failure.message).to eq("No shadow exists with name: 'XXxx'")
        end
      end
    end
  end
end
