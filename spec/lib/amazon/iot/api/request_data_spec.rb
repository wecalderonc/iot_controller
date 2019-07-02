require 'rails_helper'

RSpec.describe Amazon::Iot::Api::RequestData do
  let(:thing) { create(:thing, name: '2BEE81') }
  let(:type)  { :reported }
  let(:payload) { "4000002000f30017" }
  let(:client) {
    Aws::IoTDataPlane::Client.new(
      region: 'us-east-1',
      access_key_id: ENV['ACCESS_KEY'],
      secret_access_key: ENV['SECRET_KEY'],
      endpoint: ENV['AWS_IOT_ENDPOINT']
    )
  }
  let(:input) {
    {
      thing_name: thing.name,
      type: type,
      client: client,
      payload: payload,
      thing: thing
    }
  }

  describe "#call" do
    context "The type is reported" do
      it "Should call Request get " do
        VCR.use_cassette("aws_get_thing_shadow_success") do
          response = subject.(input)

          data = JSON.parse(response[:request].payload.read)["state"]["reported"]

          expect(response[:request]).to be_an_instance_of(Seahorse::Client::Response)
          expect(data).to be_truthy
        end
      end
    end

    context "The type is desired" do
      it "Should call Request update" do
        VCR.use_cassette("aws_update_thing_shadow_success") do
          input[:type] = :desired

          response = subject.(input)
          data = JSON.parse(response[:request].payload.read)["state"]["desired"]["data"]

          expect(data).to match("4000002000f30017")
          expect(response[:request]).to be_an_instance_of(Seahorse::Client::Response)
        end
      end
    end

    context "When the client is wrong" do
      it "Should return a Failure response" do
        damaged_client = Aws::IoTDataPlane::Client.new(
          region: 'us-east-4',
          access_key_id: ENV['ACCESS_KEY'],
          secret_access_key: ENV['SECRET_KEY'],
          endpoint: ENV['AWS_IOT_ENDPOINT']
        )

        input[:client] = damaged_client

        expect { subject.(input) }.to raise_error(Aws::IoTDataPlane::Errors::ForbiddenException)
      end
    end

    context "When the thing_name is deleted" do
      it "Should return a Failure response" do
        input.delete(:thing_name)

        expect { subject.(input) }.to raise_error(ArgumentError)
      end
    end

    context "When the type is deleted" do
      it "Should return a Failure response" do
        input.delete(:type)

        expect { subject.(input) }.to raise_error(NoMethodError)
      end
    end
  end
end
