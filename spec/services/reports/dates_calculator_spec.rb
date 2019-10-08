require 'rails_helper'

RSpec.describe Reports::DatesCalculator do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:thing)    { create(:thing) }
    let(:uplink)   { create(:uplink, thing: thing, time: (Time.now - 1.month).to_i) }
    let(:uplink2)  { create(:uplink, thing: thing, time: (Time.now - 2.months).to_i) }
    let(:uplink3)  { create(:uplink, thing: thing, time: (Time.now - 3.months).to_i) }
    let(:uplink4)  { create(:uplink, thing: thing, time: (Time.now - (Time.now -  + 2.days).to_i) }
    let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - (4.months - 8.days)) }
    let(:location) { create(:location, thing: thing) }
    let(:input)    { { thing: thing } }

    context "consumption days higher than billing period days" do
      it "should return a new billing start date" do
        expected_response = {
          thing: thing,
          new_billing_start_date: Time.now - 22.days
        }

        expect(response).to be_success
        expect(response).to eq(expected_response)
      end
    end
end
