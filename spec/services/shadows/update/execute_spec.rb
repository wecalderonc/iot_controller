require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Shadows::Update::Execute do
  describe "#call" do
    context "When the action is instant cut" do
      let(:thing)       { create(:thing, name: '2BEE81') }
      let(:type)        { :desired }
      let(:action_type) { :instant_cut }
      let(:input)       { { thing_name: thing.name, type: type, action_type: action_type } }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          VCR.use_cassette("shadows_update_instant_cut_success") do
            uplink = create(:uplink, thing: thing)
            create(:accumulator, uplink: uplink, value: '00001234')

            response = subject.(input)

            expect(response).to be_success
            expect(response.success[:payload]).to match("0000003000021234")
          end
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input.delete(:thing_name)
          input.delete(:action_type)

          response = subject.(input)

          expect(response).to be_failure

          expected_response = "The action is not in the list"

          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end

    context "When the action is restore supply" do
      let(:thing)       { create(:thing, name: '2BEE81') }
      let(:type)        { :desired }
      let(:action_type) { :restore_supply }
      let(:input)       { { thing_name: thing.name, type: type, action_type: action_type } }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          VCR.use_cassette("shadows_update_restore_success") do
            response = subject.(input)

            expect(response).to be_success
            expect(response.success[:payload]).to match("0000000000010000")
          end
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input.delete(:thing_name)
          input.delete(:action_type)

          response = subject.(input)

          expect(response).to be_failure

          expected_response = "The action is not in the list"

          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end

    context "When the action is scheduled cut" do
      context "When the input method is accumulated_value" do
        let(:thing)         { create(:thing, name: '2BEE81') }
        let(:type)          { :desired }
        let(:action_type)   { :scheduled_cut }
        let(:input_method)  { :accumulated_value }
        let(:value)         { "ffff0000" }

        let(:input)         { {
          thing_name: thing.name,
          type: type, action_type: action_type,
          value: value,
          input_method: input_method
        } }

        context "When last_accumulators < value and Accumulated Value selected" do
          it "Should return a Success response" do
            VCR.use_cassette("shadows_update_scheduled_success_with_accumulated_value") do
              uplink = create(:uplink, thing: thing)
              create(:accumulator, uplink: uplink, value: '00001234')

              response = subject.(input)

              expect(response).to be_success
              expect(response.success[:payload]).to match("0100003ffff20000")
            end
          end
        end

        context "When last_accumulators > value and Accumulated Value selected" do
          it "Should return a Success response" do
            uplink = create(:uplink, thing: thing)

            input[:value] = "00001111"
            accumulator = create(:accumulator, uplink: uplink, value: '00001234')

            response = subject.(input)

            expect { CheckAccumulatorWorker.perform_async }.to change(CheckAccumulatorWorker.jobs, :size).by(1)

            expect(response).to be_failure
            expect(response.failure[:message]).to eq("Not ready for cut, calling worker")
          end
        end

        context "When the 'validation' operation fails" do
          it "Should return a Failure response" do
            input[:action_type] = :lol

            response = subject.(input)

            expect(response).to be_failure

            expected_response = "The action is not in the list"

            expect(response.failure[:message]).to eq(expected_response)
          end
        end
        context "When the 'validation' operation fails" do
          it "Should return a Failure response" do
            input[:input_method] = "aja"

            response = subject.(input)

            expect(response).to be_failure

            expected_response = {
              :input_method => ["must be Symbol"]
            }

            expect(response.failure[:message]).to eq(expected_response)
          end
        end

        context "When the 'validation' operation fails" do
          it "Should return a Failure response" do
            input[:input_method] = :aja

            response = subject.(input)

            expect(response).to be_failure

            expected_response = {
              :input_method => ["must be one of: consumption, accumulated_value"]
            }

            expect(response.failure[:message]).to eq(expected_response)
          end
        end

        context "When the 'validation' operation fails" do
          it "Should return a Failure response" do
            input.delete(:input_method)

            response = subject.(input)

            expect(response).to be_failure

            expected_response = {
              :input_method => ["must be filled"]
            }

            expect(response.failure[:message]).to eq(expected_response)
          end
        end

        context "When the 'validation' operation fails" do
          it "Should return a Failure response" do
            input.delete(:value)

            response = subject.(input)

            expect(response).to be_failure

            expected_response = {
              :value=> ["must be filled"]
            }

            expect(response.failure[:message]).to eq(expected_response)
          end
        end
      end

      context "When the input method is consumption" do
        let(:thing)         { create(:thing, name: '2BEE81') }
        let(:type)          { :desired }
        let(:action_type)   { :scheduled_cut }
        let(:input_method)  { :consumption }
        let(:value)         { "00000001" }

        let(:input)         { {
          thing_name: thing.name,
          type: type, action_type: action_type,
          value: value,
          input_method: input_method
        } }

        context "When all the operations are successful" do
          it "Should return a Success response" do
            VCR.use_cassette("shadows_update_scheduled_success") do
              uplink = create(:uplink, thing: thing)
              create(:accumulator, uplink: uplink, value: '00001234')

              response = subject.(input)

              expect(response).to be_success
              expect(response.success[:payload]).to match("0100003000021235")
            end
          end
        end

        context "When the 'check_accumulator' operation go to sidekiq" do
          it "Should return a Failure response" do
            uplink = create(:uplink, thing: thing)

            input[:value] = "ffffffff"
            accumulator = create(:accumulator, uplink: uplink, value: '00001234')

            response = subject.(input)

            expect { CheckAccumulatorWorker.perform_async }.to change(CheckAccumulatorWorker.jobs, :size).by(1)

            expect(response).to be_failure
            expect(response.failure[:message]).to eq("Not ready for cut, calling worker")
          end
        end

        context "When the action is not in the list" do
          it "Should return a Failure response" do
            input[:action_type] = :lol

            response = subject.(input)

            expect(response).to be_failure

            expected_response = "The action is not in the list"

            expect(response.failure[:message]).to eq(expected_response)
          end
        end
      end
    end

    context "When the action is scheduled restore supply" do
      context "When the input method is accumulated_value" do
        let(:thing)         { create(:thing, name: '2BEE81') }
        let(:type)          { :desired }
        let(:action_type)   { :restore_supply_with_scheduled_cut }
        let(:input_method)  { :accumulated_value }
        let(:value)         { "ffff0000" }

        let(:input)         { {
          thing_name: thing.name,
          type: type, action_type: action_type,
          value: value,
          input_method: input_method
        } }

        context "When last_accumulators < value and Accumulated Value selected" do
          it "Should return a Success response" do
            VCR.use_cassette("shadows_update_scheduled_restore_supply_consumption_accumulated_success") do
              uplink = create(:uplink, thing: thing)
              create(:accumulator, uplink: uplink, value: '00001234')

              response = subject.(input)

              expect(response).to be_success
              expect(response.success[:payload]).to match("0100003ffff20000")
            end
          end
        end

        context "When last_accumulators > value and Accumulated Value selected" do
          it "Should return a Success response" do
            uplink = create(:uplink, thing: thing)

            input[:value] = "00001111"
            accumulator = create(:accumulator, uplink: uplink, value: '00001234')

            response = subject.(input)

            expect { CheckAccumulatorWorker.perform_async }.to change(CheckAccumulatorWorker.jobs, :size).by(1)

            expect(response).to be_failure
            expect(response.failure[:message]).to eq("Not ready for cut, calling worker")
          end
        end

        context "When the 'validation' operation fails" do
          it "Should return a Failure response" do
            input[:action_type] = :lol

            response = subject.(input)

            expect(response).to be_failure

            expected_response = "The action is not in the list"
            expect(response.failure[:message]).to eq(expected_response)
          end
        end
      end

      context "When the input method is consumption" do
        let(:thing)         { create(:thing, name: '2BEE81') }
        let(:type)          { :desired }
        let(:action_type)   { :restore_supply_with_scheduled_cut }
        let(:input_method)  { :consumption }
        let(:value)         { "00000001" }

        let(:input)         { {
          thing_name: thing.name,
          type: type, action_type: action_type,
          value: value,
          input_method: input_method
        } }

        context "When all the operations are successful" do
          it "Should return a Success response" do
            VCR.use_cassette("shadows_update_scheduled_restore_supply_consumption_success") do
              uplink = create(:uplink, thing: thing)
              create(:accumulator, uplink: uplink, value: '00001234')

              response = subject.(input)

              expect(response).to be_success
              expect(response.success[:payload]).to match("0100003000021235")
            end
          end
        end

        context "When the 'check_accumulator' operation go to sidekiq" do
          it "Should return a Failure response" do
            uplink = create(:uplink, thing: thing)

            input[:value] = "ffffffff"
            accumulator = create(:accumulator, uplink: uplink, value: '00001234')

            response = subject.(input)

            expect { CheckAccumulatorWorker.perform_async }.to change(CheckAccumulatorWorker.jobs, :size).by(1)

            expect(response).to be_failure
            expect(response.failure[:message]).to eq("Not ready for cut, calling worker")
          end
        end

        context "When the input has not have value" do
          it "Should return a Failure response" do
            input.delete(:value)

            response = subject.(input)

            expect(response).to be_failure

            expected_response = { :value => ["must be filled"] }

            expect(response.failure[:message]).to eq(expected_response)
          end
        end

        context "When the input has not have a valid value" do
          it "Should return a Failure response" do
            input[:value] = 345354

            response = subject.(input)

            expect(response).to be_failure

            expected_response = { :value => ["must be a string"] }

            expect(response.failure[:message]).to eq(expected_response)
          end
        end

        context "When the action is not in the list" do
          it "Should return a Failure response" do
            input[:action_type] = :lol

            response = subject.(input)

            expect(response).to be_failure

            expected_response = "The action is not in the list"

            expect(response.failure[:message]).to eq(expected_response)
          end
        end

        context "When the 'validation' operation fails" do
          it "Should return a Failure response" do
            input[:input_method] = "aja"

            response = subject.(input)

            expect(response).to be_failure

            expected_response = {
              :input_method => ["must be Symbol"]
            }

            expect(response.failure[:message]).to eq(expected_response)
          end
        end

        context "When the 'validation' operation fails" do
          it "Should return a Failure response" do
            input[:input_method] = :aja

            response = subject.(input)

            expect(response).to be_failure

            expected_response = {
              :input_method => ["must be one of: consumption, accumulated_value"]
            }

            expect(response.failure[:message]).to eq(expected_response)
          end
        end
      end
    end
  end
end
