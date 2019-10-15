require 'rails_helper'

RSpec.describe Reports::ProjectedConsumption do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:location) { create(:location, schedule_billing: billing) }
    let(:thing)    { create(:thing, locates: location) }
    let(:uplink)   { create(:uplink, thing: thing, time: (DateTime.now - 1.month).to_i) }
    let(:uplink2)  { create(:uplink, thing: thing, time: (DateTime.now - 2.months).to_i) }
    let(:uplink3)  { create(:uplink, thing: thing, time: (DateTime.now - 3.months).to_i) }
    let(:uplink4)  { create(:uplink, thing: thing, time: (DateTime.now - 2.days).to_i) }
    let(:input)    { { consumptions_by_month: { '4': value: 256, days_count: 20, months: [5, 6]} } }

    context "consumption days higher than billing period days" do
      let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - (4.months - 8.days)) }
      let(:accumulator)  { create( :accumulator, value: '0', uplink: uplink) }
      let(:accumulator2) { create( :accumulator, value: '20', uplink: uplink2) }
      let(:accumulator3) { create( :accumulator, value: '40', uplink: uplink3) }
      let(:accumulator4) { create( :accumulator, value: '100', uplink: uplink4) }

      it "should return a new billing start date" do

        expected_response = {
          thing: thing,
          new_billing_start_date: start_date,
          consumptions_by_month: {
            '1': {
              value: 0,
              days_count: 30,
              months: [(DateTime.now - 3.months).month]
            },
            '2': {
              value: 20,
              days_count: 30,
              months: [(DateTime.now - 2.months).month]
            },
            '3': {
              value: 40,
              days_count: 30,
              months: [(DateTime.now - 1.months).month]
            },
            '4': {
              value: 100,
              days_count: 22,
              months: [(DateTime.now - 2.days).month]
            }
          },
          projected_consumption: {
            value: 160,
            days_count: 8
          }
        }

        expect(response).to be_success
        expect(response.success).to eq(expected_response)
      end
    end
  end
end
