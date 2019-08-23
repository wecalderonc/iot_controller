require 'rails_helper'

Rspec.describe CitySerializer do
  let(:city) { build(:city) }
  let(:state) { city.state }
  let(:country) { state.country }
  let(:serializer) { described_class.new(city) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  context "The state is ok" do
    it "Should return a hash" do

      expected_response = {
        "name"=>city.name,
        "state"=> {
          "name"=>state.name,
          "code_iso"=>state.code_iso
        }
      }
      
      expect(subject).to match(expected_response)
    end
  end
end
