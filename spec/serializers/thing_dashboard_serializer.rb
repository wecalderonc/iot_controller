require 'rails_helper'

Rspec.describe ThingDashboardSerializer do
  let(:thing) { build(:thing) }
  let(:serializer) { described_class.new(thing) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  context "The thing is ok" do
    it "Should return a hash" do
      expected_response = {
        "id"=>nil,
        "name"=>thing.name,
        "new_alarms" => false,
        "valve_transition"=>{
          "real_state"=>thing.valve_transition.real_state,
          "showed_state"=>thing.valve_transition.showed_state,
        },
        "last_battery_level"=>{}
      }

      expect(subject).to eq(expected_response)
    end
  end

  context "The thing is ok" do
    let(:alarm)   { create(:alarm, viewed: true) }
    let(:thing)   { alarm.uplink.thing }
    let(:uplink)  { alarm.uplink }
    let!(:batteryLevel) { create(:battery_level, value: "0001", uplink: uplink) }

    it "Should return a hash whit true value in new_alarms " do

      expected_response = {
        "id"=>thing.id,
        "name"=>thing.name,
        "new_alarms" => true,
        "valve_transition"=>{
          "real_state"=>thing.valve_transition.real_state,
          "showed_state"=>thing.valve_transition.showed_state,
        },
        "last_battery_level"=>{
          "id"=>batteryLevel.id,
          "value"=>batteryLevel.value,
          "created_at"=>JSON.parse(batteryLevel.created_at.to_json),
          "updated_at"=>JSON.parse(batteryLevel.updated_at.to_json),
          "level_label"=>"low"
        }
      }

      expect(subject).to eq(expected_response)
    end
  end
end
