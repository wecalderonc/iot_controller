require 'rails_helper'

Rspec.describe BatteryLevelSerializer do
  let(:base_obj) { create(:uplink) }
  let(:serializer) { described_class.new(base_obj) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  before do
  end

  context "The thing is ok" do
    it "Should return a hash" do
      expected_response = {
        "id"=>nil,
        "value"=>"",
        "status"=>"activated"
      }

      expect(subject).to eq(expected_response)
    end
  end
end
