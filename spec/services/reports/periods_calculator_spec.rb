require 'rails_helper'

RSpec.describe Reports::PeriodsCalculator do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:location) { create(:location, schedule_billing: billing) }
    let(:thing)    { create(:thing, units: { liter: 200 }, locates: location) }
#   let(:uplink)   { create(:uplink, thing: thing, time: (Time.now - 1.month).to_i) }
#   let(:uplink2)  { create(:uplink, thing: thing, time: (Time.now - 2.months).to_i) }
#   let(:uplink3)  { create(:uplink, thing: thing, time: (Time.now - 3.months).to_i) }
    let(:uplink4)  { create(:uplink, thing: thing, time: (Time.now - 2.days).to_i ) }
    let(:input)    { { thing: thing, new_billing_start_date: Date.today - 22.days, unit: :liter } }
    

    context "there are accumulators from lower than one periods ago" do
      let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - (4.months - 8.days)) }
      let(:accumulator) { create(:accumulator, value: '100', uplink: uplink4) }

      it "should return one period with consumption " do
        start_date = Date.today - 22.days,
        end_date = Date.today
        puts "*" * 100
        puts response.inspect
        puts "*" * 100

        expected_response = {
          thing: thing,
          new_billing_start_date:  start_date,
          consumptions_by_month: {
            '1': {
              value: 0,
              days_count: 30,
              months: [(Time.now - 3.months).month]
            },
            '2': {
              value: 0,
              days_count: 30,
              months: [(Time.now - 2.months).month]
            },
            '3': {
              value: 0,
              days_count: 30,
              months: [(Time.now - 1.months).month]
            },
            '4': {
              value: 51200.0,
              days_count: 22,
              months: (Time.now - 2.days).month
            }
          }
        }

        expect(response).to be_success
        expect(response.success).to eq(expected_response)
      end
    end

    context "consumption days lower than billing period days" do
      let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - 8.days) }

      it "should return a new billing start date" do
        expected_response = {
        }

        expect(response).to be_success
        expect(response.success).to eq(expected_response)
      end
    end
  end
end
