require 'rails_helper'

Rspec.describe AccumulatorSerializer do
  let(:base_obj) { build(:accumulator, value: '190') }
  let(:serializer) { described_class.new(base_obj) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  before do
    create(:price, value: 2000)

    thing = base_obj.uplink.thing
    thing.units[:liter] = 200
    thing.save
  end

  context "The object is ok" do
    it "Should return a hash" do
      expected_response = {
        "id"=>nil,
        "created_at"=>nil,
        "id"=>nil,
        "updated_at"=>nil,
        "value"=>base_obj.value,
        "final_price"=>4000.0,
        "units_count"=>2.0
      }

      expect(subject).to eq(expected_response)
    end
  end
end
