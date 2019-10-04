require 'rails_helper'

Rspec.describe ThingSerializer do
  let(:thing) { build(:thing) }
  let(:serializer) { described_class.new(thing) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  context "The thing is ok" do
    it "Should return a hash" do
      expected_response = {
        "id"=>nil,
        "name"=>thing.name,
        "status"=>"activated",
        "new_alarms"=>false,
        "pac"=>thing.pac,
        "company_id"=>thing.company_id,
        "latitude"=>thing.latitude,
        "longitude"=>thing.longitude,
        "units"=>{"liter"=>thing.units[:liter]},
        "created_at"=>nil,
        "updated_at"=>nil,
        "valve_transition"=>{
          "real_state"=>thing.valve_transition.real_state,
          "showed_state"=>thing.valve_transition.showed_state,
        },
        "last_uplink"=>[],
        "last_messages"=> {
          "accumulator"=>{},
          "alarm"=>{},
          "batteryLevel"=>{},
          "valvePosition"=>{},
          "sensor1"=>{},
          "sensor2"=>{},
          "sensor3"=>{},
          "sensor4"=>{},
          "uplinkBDownlink"=>{},
          "timeUplink"=>{}
        }
      }

      expect(subject).to eq(expected_response)
    end
  end
end
