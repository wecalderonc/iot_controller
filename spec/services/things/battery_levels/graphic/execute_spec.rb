require 'rails_helper'

RSpec.describe Things::BatteryLevels::Graphic::Execute do
  describe "#call" do
    let(:thing)           { create(:thing) }
    let(:uplink)          { create(:uplink, thing: thing) }
    let(:uplink1)         { create(:uplink, thing: thing) }
    let(:uplink2)         { create(:uplink, thing: thing) }
    let(:uplink3)         { create(:uplink, thing: thing) }
    let(:uplink4)         { create(:uplink, thing: thing) }
    let(:uplink5)         { create(:uplink, thing: thing) }
    let(:uplink6)         { create(:uplink, thing: thing) }

    context "When the thing has battery levels with upward_transition AFTER alarm power connection" do
      let!(:alarm)           { create(:alarm, value: "0001", created_at: DateTime.new(2019,10,1), uplink: uplink1)}
      let!(:battery_level)   { create(:battery_level, value: "0005", uplink: uplink, created_at: DateTime.new(2019,10,1)) }
      let!(:battery_level2)  { create(:battery_level, value: "0004", uplink: uplink2, created_at: DateTime.new(2019,10,2)) }
      let!(:battery_level3)  { create(:battery_level, value: "0005", uplink: uplink3, created_at: DateTime.new(2019,10,3)) }
      let!(:battery_level4)  { create(:battery_level, value: "0003", uplink: uplink4, created_at: DateTime.new(2019,10,4)) }
      let!(:battery_level5)  { create(:battery_level, value: "0002", uplink: uplink5, created_at: DateTime.new(2019,10,5)) }
      let!(:battery_level6)  { create(:battery_level, value: "0001", uplink: uplink6, created_at: DateTime.new(2019,10,6)) }
      let(:input) {
        {
          thing_name: thing.name
        }
      }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success[0]).to eq(battery_level3)
          expect(response.success[1]).to eq(battery_level4)
          expect(response.success[2]).to eq(battery_level5)
          expect(response.success[3]).to eq(battery_level6)
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
    end

    context "When the thing has battery levels upward_transition BEFORE alarm power connection" do
      let!(:alarm)           { create(:alarm, value: "0001", created_at: DateTime.new(2019,10,4), uplink: uplink1)}
      let!(:battery_level)   { create(:battery_level, value: "0004", uplink: uplink, created_at: DateTime.new(2019,10,1)) }
      let!(:battery_level2)  { create(:battery_level, value: "0005", uplink: uplink2, created_at: DateTime.new(2019,10,2)) }
      let!(:battery_level3)  { create(:battery_level, value: "0004", uplink: uplink3, created_at: DateTime.new(2019,10,3)) }
      let!(:battery_level4)  { create(:battery_level, value: "0003", uplink: uplink4, created_at: DateTime.new(2019,10,4)) }
      let!(:battery_level5)  { create(:battery_level, value: "0002", uplink: uplink5, created_at: DateTime.new(2019,10,5)) }
      let!(:battery_level6)  { create(:battery_level, value: "0001", uplink: uplink6, created_at: DateTime.new(2019,10,6)) }
      let(:input) {
        {
          thing_name: thing.name
        }
      }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success[0]).to eq(battery_level5)
          expect(response.success[1]).to eq(battery_level6)
        end
      end
    end

    context "When the thing does not have battery levels upward_transition and does not have alarm power connection" do
      let!(:alarm)           { create(:alarm, value: "0002", created_at: DateTime.new(2019,10,4), uplink: uplink1)}
      let!(:battery_level)   { create(:battery_level, value: "0005", uplink: uplink, created_at: DateTime.new(2019,10,1)) }
      let!(:battery_level2)  { create(:battery_level, value: "0004", uplink: uplink2, created_at: DateTime.new(2019,10,2)) }
      let!(:battery_level3)  { create(:battery_level, value: "0003", uplink: uplink3, created_at: DateTime.new(2019,10,3)) }
      let!(:battery_level4)  { create(:battery_level, value: "0002", uplink: uplink4, created_at: DateTime.new(2019,10,4)) }
      let!(:battery_level5)  { create(:battery_level, value: "0001", uplink: uplink5, created_at: DateTime.new(2019,10,5)) }
      let(:input) {
        {
          thing_name: thing.name
        }
      }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success[0]).to eq(battery_level)
          expect(response.success[1]).to eq(battery_level2)
          expect(response.success[2]).to eq(battery_level3)
          expect(response.success[3]).to eq(battery_level4)
          expect(response.success[4]).to eq(battery_level5)
        end
      end
    end

    context "When the thing does not have battery levels upward_transition and have alarm power connection" do
      let!(:alarm)           { create(:alarm, value: "0001", created_at: DateTime.new(2019,10,3), uplink: uplink1)}
      let!(:battery_level)   { create(:battery_level, value: "0005", uplink: uplink, created_at: DateTime.new(2019,10,1)) }
      let!(:battery_level2)  { create(:battery_level, value: "0004", uplink: uplink2, created_at: DateTime.new(2019,10,2)) }
      let!(:battery_level3)  { create(:battery_level, value: "0003", uplink: uplink3, created_at: DateTime.new(2019,10,3)) }
      let!(:battery_level4)  { create(:battery_level, value: "0002", uplink: uplink4, created_at: DateTime.new(2019,10,4)) }
      let!(:battery_level5)  { create(:battery_level, value: "0001", uplink: uplink5, created_at: DateTime.new(2019,10,5)) }
      let(:input) {
        {
          thing_name: thing.name
        }
      }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success[0]).to eq(battery_level4)
          expect(response.success[1]).to eq(battery_level5)
        end
      end
    end

    context "When the thing does not have battery levels" do
      let(:input) {
        {
          thing_name: thing.name
        }
      }

      it "Should return a Failure response" do
        response = subject.(input)

        expect(response).to be_failure
        expect(response.failure[:message]).to eq("The thing #{thing.name} does not have battery level history")
      end
    end
  end
end
