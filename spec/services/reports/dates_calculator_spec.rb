require 'rails_helper'

RSpec.describe Reports::DatesCalculator do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:location) { create(:location, schedule_billing: billing) }
    let(:thing)    { create(:thing, locates: location) }
    let(:input)    { { thing: thing } }

    context "consumption days higher than billing period days" do
      let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - (3.months + 22.days)) }

      it "should return a new billing start date" do
        expected_response = {
          thing: thing,
          new_billing_start_date: Date.today - 22.days
        }

        expect(response).to eq(expected_response)
      end
    end

    context "consumption days lower than billing period days" do
      let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - 8.days) }

      it "should return a new billing start date" do
        expected_response = {
          thing: thing,
          new_billing_start_date: billing.start_date
        }

        expect(response).to eq(expected_response)
      end
    end
  end
end
