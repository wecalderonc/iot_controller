require 'rails_helper'

RSpec.describe Reports::HistoricalCalculator do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:location) { create(:location, schedule_billing: billing) }
    let(:thing)    { create(:thing, units: { liter: 200 }, locates: location) }
    let(:uplink4)  { create(:uplink, thing: thing, time: (Time.now - 2.days).to_i ) }
    let(:input)    { { thing: thing, new_billing_start_date: Date.today - 22.days } }
    let!(:price)   { create(:price) }
    

    context "there are accumulators from lower than one periods ago" do
      let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: Date.today - (3.months - 8.days)) }
      let!(:accumulator) { create(:accumulator, value: '100', uplink: uplink4) }

      it "should return one period with consumption" do
        start_date = Date.today - 22.days
        end_date = Date.today

        expected_response = {
          thing: thing,
          new_billing_start_date:  start_date,
          consumptions_by_month: {
            '1' => {
              value: 0.0,
              days_count: ((start_date - 2.months - 1.day) - (start_date - 3.months)).to_i,
              months: ((start_date - 3.months)..(start_date - 2.months)).map(&:month).uniq
            },
            '2'=> {
              value: 0.0,
              days_count: ((start_date - 1.month - 1.day) - (start_date - 2.months)).to_i,
              months: ((start_date - 2.months)..(start_date - 1.months)).map(&:month).uniq
            },
            '3' => {
              value: 0.0,
              days_count: ((start_date - 1.day) - (start_date - 1.month)).to_i,
              months: ((start_date - 1.months)..start_date).map(&:month).uniq
            },
            '4' => {
              value: 51200.0,
              days_count: 22,
              months: (start_date..end_date).map(&:month).uniq
            }
          }
        }

        expect(response).to match(expected_response)
      end
    end

    context "there are accumulators from higher than one periods ago" do
      let(:billing)       { create(:schedule_billing, billing_frequency: 1, start_date: Date.today - (3.months - 8.days)) }
      let(:uplink)        { create(:uplink, thing: thing, time: (Time.now - 1.month).to_i) }
      let(:uplink2)       { create(:uplink, thing: thing, time: (Time.now - 2.months).to_i) }
      let(:uplink3)       { create(:uplink, thing: thing, time: (Time.now - 3.months).to_i) }
      let!(:accumulator)  { create(:accumulator, value: '100', uplink: uplink4) }
      let!(:accumulator2) { create(:accumulator, value: '110', uplink: uplink3) }
      let!(:accumulator3) { create(:accumulator, value: '120', uplink: uplink2) }
      let!(:accumulator4) { create(:accumulator, value: '130', uplink: uplink) }

      it "should return one period with consumption" do
        start_date = Date.today - 22.days
        end_date = Date.today

        expected_response = {
          thing: thing,
          new_billing_start_date:  start_date,
          consumptions_by_month: {
            '1' => {
              value: 54400.0,
              days_count: ((start_date - 2.months - 1.day) - (start_date - 3.months)).to_i,
              months: ((start_date - 3.months)..(start_date - 2.months)).map(&:month).uniq
            },
            '2'=> {
              value: 57600.0,
              days_count: ((start_date - 1.month - 1.day) - (start_date - 2.months)).to_i,
              months: ((start_date - 2.months)..(start_date - 1.months)).map(&:month).uniq
            },
            '3' => {
              value: 60800.0,
              days_count: ((start_date - 1.day) - (start_date - 1.month)).to_i,
              months: ((start_date - 1.months)..start_date).map(&:month).uniq
            },
            '4' => {
              value: 51200.0,
              days_count: 22,
              months: (start_date..end_date).map(&:month).uniq
            }
          }
        }

        expect(response).to match(expected_response)
      end
    end
  end
end
