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

  context "The thing is ok" do
    let(:alarm)   { create(:alarm, viewed: true) }
    let(:thing)   { alarm.uplink.thing }
    let(:uplink)  { alarm.uplink }
    let!(:batteryLevel) { create(:battery_level, uplink: uplink) }

    it "Should return a hash whit true value in new_alarms " do

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
        "last_uplink"=>[
          "uplink"=> {
            "avgsnr"=> uplink.avgsnr,
            "created_at"=>JSON.parse(uplink.created_at.to_json),
            "data" =>uplink.data,
            "id" =>uplink.id,
            "lat" =>uplink.lat,
            "long" =>uplink.long,
            "rssi" =>uplink.rssi,
            "sec_downlinks" =>uplink.sec_downlinks,
            "sec_uplinks" =>uplink.sec_uplinks,
            "seqnumber" =>uplink.seqnumber,
            "snr" =>uplink.snr,
            "station" =>uplink.station,
            "time" =>uplink.time,
            "updated_at"=>JSON.parse(uplink.updated_at.to_json),
          }
        ],
        "last_messages"=> {
          "accumulator"=>{},
          "alarm"=>{
            "created_at" =>JSON.parse(alarm.created_at.to_json),
            "id" =>alarm.id,
            "updated_at" =>JSON.parse(alarm.updated_at.to_json),
            "value" =>alarm.value,
            "viewed" =>alarm.viewed,
            "viewed_date" =>JSON.parse(alarm.viewed_date.to_json),
          },
          "batteryLevel"=>{
            "created_at" =>JSON.parse(batteryLevel.created_at.to_json),
            "id" =>batteryLevel.id,
            "level_label" =>BatteryLevelSerializer.new(batteryLevel).level_label.to_s,
            "updated_at" =>JSON.parse(batteryLevel.updated_at.to_json),
            "value" =>batteryLevel.value,
          },
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
