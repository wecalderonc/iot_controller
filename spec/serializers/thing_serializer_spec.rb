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
        "new_alarms" => false,
        "status"=>"activated",
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

      puts "*" * 100
      puts thing.inspect
      puts subject.inspect
      puts "*" * 100
      expect(subject).to eq(expected_response)
    end
  end

  context "The thing is ok" do
    let(:alarm) { create(:alarm, viewed: true) }
    let(:thing) { alarm.uplink.thing }

    it "Should return a hash whit true value in new_alarms " do
      puts "thing ............................"
      puts subject.inspect
      puts "thing ............................"

      expected_response = {
        "id"=>thing.id,
        "name"=>thing.name,
        "new_alarms" => true,
        "status"=>"activated",
        "pac"=>thing.pac,
        "company_id"=>thing.company_id,
        "latitude"=>thing.latitude,
        "longitude"=>thing.longitude,
        "units"=>thing.units,
        "created_at"=>JSON.parse(thing.created_at.to_json),
        "updated_at"=>JSON.parse(thing.updated_at.to_json),
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
