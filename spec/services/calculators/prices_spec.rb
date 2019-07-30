require 'rails_helper'

RSpec.describe Calculators::Prices::Execute do
  describe "#call" do
    let(:currency) { 'COP' }
    let(:unit)     { :liter }
    let(:thing)    { create(:thing, units: { liter: 200 }) }
    let(:uplink1)  { create(:uplink, thing: thing, created_at: Time.zone.now) }
    let(:uplink2)  { create(:uplink, thing: thing, created_at: Time.zone.now + 1.minutes) }

    before { Timecop.freeze(Time.zone.now) }
    after  { Timecop.return }

    #context "The current currency is different to the original once" do
    #  it "should return the price of the last accumulator value" do
    #    price1 = create(:price, unit: 'cubic_metter')
    #    price2 = create(:price, value: 2000)

    #    create(:accumulator, uplink: uplink1, value: "C8")
    #    create(:accumulator, uplink: uplink2, value: "190")

    #    result = subject.(thing: thing, unit: unit, currency: currency)

    #    expect(result).to be_success
    #    expect(result.success).to eq(4000)
    #  end
    #end

    #context "The current currency is the same asked currency" do
    #  it "should return the price of the last accumulator value in USD" do
    #    price1 = create(:price, unit: 'cubic_metter')
    #    price2 = create(:price, value: 2000)

    #    create(:accumulator, uplink: uplink1, value: "C8")
    #    create(:accumulator, uplink: uplink2, value: "190")

    #    currency = 'USD'

    #    result = subject.(thing: thing, unit: unit, currency: currency)

    #    expect(result).to be_success
    #    expect(result.success).to eq(1)
    #  end
    #end

    context "There are no Thing" do
      it "should return a failure result" do
        result = subject.(unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq(:thing => ["is missing"])

        result = subject.(thing: {}, unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq(:thing => ["must be filled"])

        result = subject.(thing: User, unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq(:thing => ["must be Thing"])
      end
    end

    context "There are not accumulators" do
      it "should return the price of tha" do
        price1 = create(:price, unit: 'cubic_metter')
        price2 = create(:price, value: 2000)

        result = subject.(thing: thing, unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq("There are not accumulators")
      end
    end

    context "There are not prices" do
      it "should return a failure result" do
        create(:accumulator, uplink: uplink2, value: "190")

        result = subject.(thing: thing, unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq("There are any configured prices")
      end
    end

    context "There are not prices" do
      it "should return a failure result" do
        create(:price, value: 2000)
        create(:accumulator, uplink: uplink2, value: "190")

        unit = :aja

        result = subject.(thing: thing, unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq("There are any configured prices")
      end
    end

    context "The currency does not exist" do
      it "should return a failure result" do
        create(:price, value: 2000)
        create(:accumulator, uplink: uplink2, value: "190")

        currency = 'aja'

        result = subject.(thing: thing, unit: unit, currency: currency)

        expect(result).to be_failure
        expect(result.failure[:message]).to eq({:valid_currency=>["The currency does not exist"]})
      end
    end
  end
end
