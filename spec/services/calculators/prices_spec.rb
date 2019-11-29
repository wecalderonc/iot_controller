require 'rails_helper'

RSpec.describe Calculators::Prices::Execute do
  describe "#call" do
    let(:currency) { 'COP' }
    let(:unit)     { :liter }
    let(:thing)    { create(:thing, units: { liter: 200 }) }
    let(:uplink)   { create(:uplink, thing: thing, created_at: Time.zone.now + 1.minutes) }

    before { Timecop.freeze(Time.zone.now) }
    after  { Timecop.return }

    context "The current currency is different to the original once" do
      it "should return the price of the last accumulator value" do
        price1 = create(:price, unit: 'cubic_metter')
        price2 = create(:price, value: 2000)

        accumulator = create(:accumulator, uplink: uplink, value: "190")

        result = subject.(accumulator: accumulator, unit: unit)

        expect(result).to be_success

        expected_response = { units_count: 2.0, final_price: 4000 }

        expect(result.success).to eq(expected_response)
      end
    end

    context "There are no Thing" do
      it "should return a failure result" do
        result = subject.(unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq(:accumulator => ["is missing"])

        result = subject.(accumulator: {}, unit: unit)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq(:accumulator => ["must be filled"])

        result = subject.(accumulator: User, unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq(:accumulator => ["must be Accumulator"])
      end
    end

    context "There are not prices" do
      it "should return a failure result" do
        accumulator = create(:accumulator, uplink: uplink, value: "190")

        result = subject.(accumulator: accumulator, unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq("There are any configured prices")
      end
    end

    context "There are not prices" do
      it "should return a failure result" do
        create(:price, value: 2000)
        accumulator = create(:accumulator, uplink: uplink, value: "190")

        unit = :aja

        result = subject.(accumulator: accumulator, unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq("There are any configured prices")
      end
    end
  end
end
