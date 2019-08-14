require 'rails_helper'

Rspec.describe UplinkBDownlinkSerializer do
  let(:base_obj) { build(:uplink_b_downlink) }
  let(:serializer) { described_class.new(base_obj) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  context "The object is ok" do
    it "Should return a hash" do
      expected_response = {
        "id"=>nil,
        "created_at"=>nil,
        "id"=>nil,
        "updated_at"=>nil,
        "value"=>base_obj.value
      }

      expect(subject).to eq(expected_response)
    end
  end
end
