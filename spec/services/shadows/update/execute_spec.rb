require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Amazon::Iot::Shadows::Update::Execute do
  describe "#call" do
    context "When the action is scheduled" do
      let(:thing) { create(:thing) }
      let(:type)  { :desired }
      let(:action){ :restore_supply}
      let(:input) { { thing_name: thing.name, type: type, action: action } }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success[:payload]).to match("0000000000010000")
        end
      end

      context "When the 'api' operation fails" do
        it "Should return a Failure response" do
          input.delete(:thing_name)
          response = subject.(input)

          expect(response).to be_failure
          expect(response.failure[:error]).to eq("Device doesn't exist in BD")
        end
      end

      context "When the 'build_payload' operation fails" do
        it "Should return a error response" do
          input.delete(:action)
          response = subject.(input)

          expect(response.failure[:error]).to eq("Action no exist")
        end
      end
    end

    context "When the action is scheduled" do
      let(:thing)         { create(:thing) }
      let(:type)          { :desired }
      let(:action)        { :scheduled_cut }
      let(:input_method)  { :consumption }
      let(:value)         { "00000001" }
      let(:input)         { { thing_name: thing.name, type: type, action: action, value: value, input_method: input_method } }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          uplink = create(:uplink, thing: thing)
          accumulator = create(:acumulator, uplink: uplink)
          response = subject.execute(input)

          expect(response).to be_success
          expect(response.success[:payload]).to match("0100003000021235")
        end
      end

      context "When the 'check_accumulator' operation go to sidekiq" do
        it "Should return a Failure response" do
          uplink = create(:uplink, thing: thing)
          input[:value] = "ffffffff"
          accumulator = create(:acumulator, uplink: uplink)
          response = subject.execute(input)

          expect { CheckAccumulatorWorker.perform_async }.to change(CheckAccumulatorWorker.jobs, :size).by(1)
        end
      end

      context "When the 'usds' operation fails" do
        it "Should return a Failure response" do
          uplink = create(:uplink, thing: thing)
          accumulator = create(:acumulator, uplink: uplink)
          input[:action] = "lol"
          input[:value] = "10000000"

          response = subject.execute(input)

          expect(response).to be_failure
          expect(response.failure[:error]).to eq("Action no exist")
        end
      end
    end
  end
end
