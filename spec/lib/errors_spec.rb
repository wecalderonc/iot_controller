require 'rails_helper'

RSpec.describe Errors do
  let(:subject) { described_class }
  let(:status)  { :success }
  let(:message) { "this is a message"}
  let(:location) { self.class }

  describe "#failed_request" do
    it "Should return a hash" do
      response = subject.failed_request(status, message)
      expected_response = { status: status, message: message }

      expect(response).to eq(expected_response)
    end
  end

  describe "#general_error" do
    it "Should return a hash" do
      response = subject.general_error(status, self.location)
      expected_response = { error: status, location: location, extra: {} }

      expect(response).to eq(expected_response)
    end
  end

  describe "#model_error" do
    context "without extra" do
      it "Should return a hash" do
        response = subject.model_error(status, message)
        expected_response = { error: status, model: message, extra: {}}

        expect(response).to eq(expected_response)
      end
    end

    context "with extra" do
      it "Should return a hash" do
        response = subject.model_error(status, message, extra: "amm aja un extra")
        expected_response = { error: status, model: message, extra: "amm aja un extra" }

        expect(response).to eq(expected_response)
      end
    end
  end
end
