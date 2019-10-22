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
        "created_at"=>thing.created_at.iso8601(3),
        "updated_at"=>thing.updated_at.iso8601(3),
        "valve_transition"=>{
          "real_state"=>thing.valve_transition.real_state,
          "showed_state"=>thing.valve_transition.showed_state,
        },
        "last_uplink"=>[
          "uplink"=> {
            "avgsnr"=> uplink.avgsnr,
            "created_at"=>uplink.created_at.iso8601(3),
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
            "updated_at"=>uplink.updated_at.iso8601(3),
          }
        ],
        "last_messages"=> {
          "accumulator"=>{},
          "alarm"=>{
            "created_at" =>alarm.created_at.iso8601(3),
            "id" =>alarm.id,
            "updated_at" =>alarm.updated_at.iso8601(3),
            "value" =>alarm.value,
            "viewed" =>alarm.viewed,
            "viewed_date" =>alarm.viewed_date.strftime("%F"),
            "name"=>alarm.alarm_type.name,
            "type"=>alarm.alarm_type.type,
            "time"=>Time.at(alarm.uplink.time.to_i).iso8601(3)
          },
          "batteryLevel"=>{
            "created_at" =>batteryLevel.created_at.iso8601(3),
            "id" =>batteryLevel.id,
            "level_label" =>BatteryLevelSerializer.new(batteryLevel).level_label.to_s,
            "updated_at" =>batteryLevel.updated_at.iso8601(3),
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
