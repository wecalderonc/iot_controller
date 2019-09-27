require 'rails_helper'

RSpec.describe Reports::Accumulators::Index::JsonFormat do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:uplink)   { create(:uplink) }
    let(:thing)    { uplink.thing }
    let(:input)    { { params: {}, model: :accumulator, thing: Thing } }

    context "There are things with accumulators related" do
      it "Should return a Success response" do
        accumulator1 = create(:accumulator, value: "00006fff", uplink: uplink)
        accumulator2 = create(:accumulator, value: "00007fff", uplink: uplink)
        accumulator3 = create(:accumulator, value: "00008fff", uplink: uplink)

        expected_response = [
          {
            "thing_id" => thing.id,
            "thing_name" => thing.name,
            "date" => accumulator1.uplink.created_at,
            "value" => accumulator1.value,
            "consumption_delta" => ""
          },
          {
            "thing_id" => thing.id,
            "thing_name" => thing.name,
            "date" => accumulator2.uplink.created_at,
            "value" => accumulator2.value,
            "consumption_delta" => ""
          }
          {
            "thing_id" => thing.id,
            "thing_name" => thing.name,
            "date" => accumulator3.uplink.created_at,
            "value" => accumulator3.value,
            "consumption_delta" => ""
          }
        ]

        expect(response).to be_success
        expect(response.success).to eq(3)
        expect(response.success).to include(expected_response)
      end
    end

    context "There aren't things with accumulators related" do
      it "Should return a Failure response" do
        expect(response).to be_failure
        expect(response.failure[:message]).to eq("Results not found")
        expect(response.failure[:code]).to eq(10104)
      end
    end
  end
end
