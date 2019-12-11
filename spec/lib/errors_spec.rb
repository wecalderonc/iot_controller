require 'rails_helper'

RSpec.describe Errors do
  let(:subject) { described_class }
  let(:status)  { :success }
  let(:message) { "this is a message"}
  let(:location) { self.class }
  let(:code)    { 10105 }

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
      expected_response = { message: status, location: location, extra: {}, code: 10101, error: status }

      expect(response).to eq(expected_response)
    end
  end

  describe "#model_error" do
    context "without extra" do
      it "Should return a hash" do
        response = subject.model_error(status, message)
        expected_response = { message: status, model: message, extra: {}}

        expect(response).to eq(expected_response)
      end
    end

    context "with extra" do
      it "Should return a hash" do
        response = subject.model_error(status, message, extra: "amm aja un extra")
        expected_response = { message: status, model: message, extra: "amm aja un extra" }

        expect(response).to eq(expected_response)
      end
    end
  end

  describe "#service_error" do
    context "without extra" do
      it "Should return a hash" do
        response = subject.service_error(status, code, location)
        expected_response = { message: status, code: code, location: location }

        expect(response).to eq(expected_response)
      end
    end
  end
end
