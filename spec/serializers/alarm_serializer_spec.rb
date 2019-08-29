require 'rails_helper'

Rspec.describe AlarmSerializer do
  let(:base_obj) { build(:alarm, viewed_date: Date.new(2019, 8, 12)) }
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
        "value"=>base_obj.value,
        "viewed"=>base_obj.viewed,
        "viewed_date"=>"2019-08-12"
      }

      expect(subject).to eq(expected_response)
    end
  end
end
