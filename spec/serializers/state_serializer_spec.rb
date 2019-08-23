require 'rails_helper'

Rspec.describe StateSerializer do
  let(:country) { build(:country) }
  let(:state) { build(:state, country: country) }
  let(:serializer) { described_class.new(state) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  context "The state is ok" do
    it "Should return a hash" do

      expected_response = {
        "name"=>state.name,
        "code_iso"=>state.code_iso,
        "country"=> {
          "name"=>country.name,
          "code_iso"=>country.code_iso
        }
      }

      expect(subject).to match(expected_response)
    end
  end
end
