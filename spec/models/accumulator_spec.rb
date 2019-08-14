require 'rails_helper'

RSpec.describe Accumulator, type: :model do

  it { is_expected.to define_property :value, :String }
  it { is_expected.to have_one(:uplink).with_direction(:out) }
  it { is_expected.to have_many(:prices).with_direction(:out) }

  describe "#int_value" do
    context "The value is AA" do
      it "Should return 170" do
        acc = create(:accumulator, value: "AA")

        expect(acc.int_value).to eq(170)
      end
    end

    context "The value is 00" do
      it "Should return 0" do
        acc = create(:accumulator, value: "00")

        expect(acc.int_value).to eq(0)
      end
    end

    context "The value is 111" do
      it "Should return 273" do
        acc = create(:accumulator, value: "111")

        expect(acc.int_value).to eq(273)
      end
    end
  end

  describe "#my_units" do
    context "The value is AA" do
      it "Should return 170" do
        acc = create(:accumulator, value: "AA")
        expected_response = {"liters"=>acc.uplink.thing.units["liters"]}

        expect(acc.my_units).to eq(expected_response)
      end
    end
  end
end
