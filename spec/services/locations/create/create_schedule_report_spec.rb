require 'rails_helper'

RSpec.describe Locations::Create::CreateScheduleReport do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:input) {
      {
        location: location,
        schedule_report: {
          email: 'unacosita@gmail.com',
          frequency_day: 1,
          frequency_interval: :week,
          start_day: 10,
          start_month: 10,
          start_year: 2019
        }
      }
    }

    context 'Creating a new schedule report' do
      let(:location) { create(:location) }
      let(:schedule_report) { location.schedule_report }

      it 'should create a new schedule report' do
        expect(response).to be_success

        expected_response = {
          location: location,
          schedule_report: schedule_report
        }

        expect(response.success).to match(expected_response)
        expect(schedule_report.email).to eq('unacosita@gmail.com')
        expect(schedule_report.frequency_day).to eq(1)
      end
    end
  end
end
