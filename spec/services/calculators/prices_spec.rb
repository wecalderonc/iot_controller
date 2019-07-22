require 'rails_helper'

RSpec.describe Calculators::Prices do
  describe "#ByThingUnit" do
    let(:currency) { 'COP' }
    let(:unit)     { 'liter' }
    let(:thing)    { create(:thing, units: { liter: 200 }) }
    let(:uplink1)  { create(:uplink, thing: thing, created_at: Time.zone.now) }
    let(:uplink2)  { create(:uplink, thing: thing, created_at: Time.zone.now + 1.minutes) }

    before { Timecop.freeze(Time.zone.now) }
    after  { Timecop.return }

    context "The current currency is different to the original once" do
      it "should return the price of tha" do
        price1 = create(:price, unit: 'cubic_metter')
        price2 = create(:price, value: 2000)

        create(:accumulator, uplink: uplink1, value: "C8")
        create(:accumulator, uplink: uplink2, value: "190")

        result = subject::ByThingUnit.new.(thing: thing, unit: unit, currency: currency)

        expect(result).to be_success
        expect(result.success).to eq(4000)
      end
    end

    context "The current currency is the same asked currency" do
      it "should return the price of tha" do
        price1 = create(:price)
        price2 = create(:price, value: 2000)
        create(:accumulator, uplink: uplink, value: 200, price: price1)
        create(:accumulator, uplink: uplink, value: 400, price: price2)

        currency = 'USD'

        result = subject::ByThingUnit.new.(thing: thing, unit: unit, currency: currency)

        expect(result).to be_success
        expect(result.success).to eq(1.3)
      end
    end

    context "There are no accumulators" do
      it "should return a failure result" do
        result = subject::ByThingUnit.(thing, unit, currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq("There are any accumulators")
      end
    end

    context "There are not prices" do
      it "should return a failure result" do
        create(:accumulator, uplink: uplink, value: 200)

        result = subject::ByThingUnit.(thing, unit, currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq("There are any configured prices")
      end
    end

    context "There are not prices" do
      it "should return a failure result" do
        price1 = create(:price)
        price2 = create(:price, price: 2000)
        create(:accumulator, uplink: uplink, value: 200, price: price1)
        create(:accumulator, uplink: uplink, value: 400, price: price2)

        unit = :aja

        result = subject::ByThingUnit.(thing, unit, currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq("There are any configured prices for #{unit}")
      end
    end

    context "The currency does not exist" do
      it "should return a failure result" do
        price1 = create(:price)
        price2 = create(:price, price: 2000)
        create(:accumulator, uplink: uplink, value: 200, price: price1)
        create(:accumulator, uplink: uplink, value: 400, price: price2)

        currency= 'aja'

        result = subject::ByThingUnit.(thing, unit, currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq("The currency is not valid")
      end
    end
  end
end
