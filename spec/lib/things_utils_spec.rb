require 'rails_helper'

RSpec.describe ThingsUtils do
  describe "#GetUplinkDate" do
    let(:result) { described_class::GetUplinkDate.(accumulator) }

    context "uplink created_at is present" do
      let(:accumulator) { create(:accumulator) }
      let(:created_at) { accumulator.uplink.created_at.strftime('%a %d %b %Y') }

      it "should return uplink created_at" do
        expect(result).to eq(created_at)
      end
    end
    context "uplink created_at is present" do
      let(:accumulator) { create(:accumulator) }

      it "should return uplink created_at" do
        accumulator.uplink.update(created_at: nil)

        expect(result).to eq("")
      end
    end
  end
end
