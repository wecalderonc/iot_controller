require 'rails_helper'

RSpec.describe Things::BatteryLevels::Graphic::Compare do
  describe "#call" do
    let(:thing)           { create(:thing) }
    let(:uplink)          { create(:uplink, thing: thing) }
    let(:uplink1)          { create(:uplink, thing: thing) }
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
          last_power_connection_alarm: alarm,
          upward_transition: battery_level4
        }
      }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response[:start_date]).to eq(battery_level4.created_at)
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
          last_power_connection_alarm: alarm,
          upward_transition: battery_level2
        }
      }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response[:start_date]).to eq(alarm.created_at)
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
          last_power_connection_alarm: nil,
          upward_transition: nil
        }
      }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response[:start_date]).to eq({})
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
          last_power_connection_alarm: alarm,
          upward_transition: nil
        }
      }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response[:start_date]).to eq(alarm.created_at)
        end
      end
    end
  end
end
