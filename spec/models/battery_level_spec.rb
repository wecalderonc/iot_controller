require 'rails_helper'

RSpec.describe BatteryLevel, type: :model do

  it { is_expected.to define_property :value, :String }
  it { is_expected.to have_one(:uplink).with_direction(:out) }

  describe "#sort_battery_levels" do
    let(:thing) { create(:thing) }
    let(:uplink) { create(:uplink, thing: thing )}
    let(:uplink2) { create(:uplink, thing: thing )}
    let(:uplink3) { create(:uplink, thing: thing )}

    context "thing has battery levels" do
      it "return alarms with 0001 value" do
        battery_level = create(:battery_level, value: "0005", uplink: uplink, created_at: DateTime.new(2019,1,1))
        battery_level2 = create(:battery_level, value: "0006", uplink: uplink, created_at: DateTime.new(2019,1,2))
        battery_level3 = create(:battery_level, value: "0005", uplink: uplink, created_at: DateTime.new(2019,1,3))
        battery_level4 = create(:battery_level, value: "0003", uplink: uplink, created_at: DateTime.new(2019,1,4))
        battery_level5 = create(:battery_level, value: "0005", uplink: uplink, created_at: DateTime.new(2019,1,5))
        battery_level6 = create(:battery_level, value: "0004", uplink: uplink, created_at: DateTime.new(2019,1,6))
        battery_levels = thing.uplinks.batteryLevel

        response = BatteryLevel.sort_battery_levels(battery_levels)

        expect(response[0]).to eq(battery_level)
        expect(response[1]).to eq(battery_level2)
        expect(response[2]).to eq(battery_level3)
        expect(response[3]).to eq(battery_level4)
        expect(response[4]).to eq(battery_level5)
        expect(response[5]).to eq(battery_level6)

      end
    end

    context "thing does not have battery_levels" do
      it "return nil" do
        battery_levels = thing.uplinks.batteryLevel
        response = BatteryLevel.sort_battery_levels(battery_levels)

        expect(response).to be_empty
      end
    end
  end
end
