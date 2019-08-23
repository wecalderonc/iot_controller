require 'rails_helper'

Rspec.describe CountrySerializer do
  let(:country) { build(:country) }
  let(:serializer) { described_class.new(country) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  context "The country is ok" do
    it "Should return a hash" do

      expected_response = {
        "name"=>country.name,
        "code_iso"=>country.code_iso
      }

      expect(subject).to match(expected_response)
    end
  end
end
