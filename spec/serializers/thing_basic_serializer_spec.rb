require 'rails_helper'

Rspec.describe ThingBasicSerializer do
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
        }
      }

      expect(subject).to eq(expected_response)
    end
  end
end
