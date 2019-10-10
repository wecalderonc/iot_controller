require 'rails_helper'

Rspec.describe LocationDashboardSerializer do
  let(:location) { build(:location) }
  let(:user) { create(:user) }
  let(:thing) { create(:thing) }
  let(:uplink) { create(:uplink, thing: thing) }
  let!(:battery_level) { create(:battery_level, uplink: uplink) }
  let(:serializer) { described_class.new(location) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  context "The location is ok" do

    it "Should return a hash" do
      thing.owner = user
      UserLocation.create(from_node: user, to_node: location)
      ThingLocation.create(from_node: thing, to_node: location)

      expected_response = {
        "name"=>location.name,
        "thing"=>{
          "id"=>thing.id,
          "name"=>thing.name,
          "new_alarms"=>false,
          "last_battery_level"=>{
            "id"=>battery_level.id,
            "value"=>battery_level.value,
            "created_at"=>JSON.parse(battery_level.created_at.to_json),
            "updated_at"=>JSON.parse(battery_level.updated_at.to_json),
            "level_label"=>"low"
          },
          "valve_transition"=>{
            "real_state"=>"not_detected",
            "showed_state"=>"not_detected"
          }
        }
      }

      expect(subject).to match(expected_response)
    end
  end
end
