require 'rails_helper'

RSpec.describe Calculators::WaterMetter do
  describe "#ReadyForConsumption" do
    let(:last_acc) { 400 }
    let(:cut_in) { 30 }

    context "last acc is gratter than cut in" do
      it "should return true" do
        result = subject::ReadyForConsumption.(last_acc, cut_in)

        expect(result).to be_truthy
      end
    end

    context "last acc is less than cut in" do
      it "should return true" do
        last_acc = 0

        result = subject::ReadyForConsumption.(last_acc, cut_in)

        expect(result).to be_truthy
      end
    end

    context "last acc is equal to cut in" do
      it "should return true" do
        last_acc = 30

        result = subject::ReadyForConsumption.(last_acc, cut_in)

        expect(result).to be_truthy
      end
    end

    context "last acc is equal to cut in" do
      it "should return false" do
        last_acc = Base::Maths.hexa_to_int('0xffffffff')

        result = subject::ReadyForConsumption.(last_acc, cut_in)

        expect(result).to be_falsey
      end
    end
  end

  describe "#ReadyForAccValue" do
    let(:last_acc) { 400 }
    let(:cut_in) { 30 }

    context "last acc is gratter than cut in" do
      it "should return false" do
        result = subject::ReadyForAccValue.(last_acc, cut_in)

        expect(result).to be_falsey
      end
    end

    context "last acc is less than cut in" do
      it "should return true" do
        last_acc = 0

        result = subject::ReadyForAccValue.(last_acc, cut_in)

        expect(result).to be_truthy
      end
    end

    context "last acc is equal to cut in" do
      it "should return false" do
        last_acc = 30

        result = subject::ReadyForAccValue.(last_acc, cut_in)

        expect(result).to be_falsey
      end
    end
  end
end
