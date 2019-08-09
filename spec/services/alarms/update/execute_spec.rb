require 'rails_helper'

RSpec.describe Alarms::Update::Execute do
  describe "#call" do
    context "When the alarm is updating viewed param" do
      let(:alarm) { create(:alarm) }
      let(:input)       {
        {
          alarm_id: alarm.id,
          params: {
            viewed: true
          }
        }
      }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success.viewed).to be_truthy
        end
      end

      context "When dont exist params" do
        it "Should return a Failure response" do
          input.delete(:params)

          response = subject.(input)
          expected_response = {
           :params => ["is missing"]
         }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When dont exist an alarm.id" do
       it "Should return a Failure response" do
         input.delete(:alarm_id)

         response = subject.(input)
         expected_response = "The alarm  does not exist"

         expect(response).to be_failure
         expect(response.failure[:message]).to eq(expected_response)
       end
     end

     context "When the viewed value is false" do
       it "Should return a Failure response" do
         input[:params][:viewed] = false

         response = subject.(input)
         expected_response = {
           :viewed => ["must be TrueClass"]
         }

         expect(response).to be_failure
         expect(response.failure[:message][:params]).to eq(expected_response)
       end
     end

     context "When the viewed value is a String" do
       it "Should return a Failure response" do
         input[:params][:viewed] = "true"

         response = subject.(input)
         expected_response = {
           :viewed => ["must be TrueClass"]
         }

         expect(response).to be_failure
         expect(response.failure[:message][:params]).to eq(expected_response)
       end
     end

     context "When the alarm.id is wrong" do
       it "Should return a Failure response" do
         input[:alarm_id] = "12345"

         response = subject.(input)
         expected_response = "The alarm 12345 does not exist"

         expect(response).to be_failure
         expect(response.failure[:message]).to eq(expected_response)
       end
     end

     context "When the input is nil" do
       it "Should return a Failure response" do
         input = nil

         response = subject.(input)
         expected_response = {
           :params => ["is missing"],
         }

         expect(response).to be_failure
         expect(response.failure[:message]).to eq(expected_response)
       end
     end

     context "When the input is empty" do
       it "Should return a Failure response" do
         input = {}

         response = subject.(input)
         expected_response = {
           :params => ["is missing"],
         }

         expect(response).to be_failure
         expect(response.failure[:message]).to eq(expected_response)
       end
     end
    end
  end
end
