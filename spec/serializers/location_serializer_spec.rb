require 'rails_helper'

Rspec.describe LocationSerializer do
  let(:location) { build(:location) }
  let(:schedule_billing) { location.schedule_billing }
  let(:schedule_report) { location.schedule_report }
  let(:serializer) { described_class.new(location) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  let(:subject) { JSON.parse(serialization.to_json) }

  context "The location is ok" do
    it "Should return a hash" do
      schedule_billing.update(start_date: Date.new(2019, 8, 22))
      schedule_report.update(start_date: Date.new(2019, 8, 22))

      expected_response = {
        "name"=>location.name,
        "address"=>location.address,
        "latitude"=>location.latitude,
        "longitude"=>location.longitude,
        "country" => location.city.state.country.code_iso,
        "state" => location.city.state.code_iso,
        "city"=> {
          "name"=>location.city.name,
        },
        "schedule_billing"=> {
          "stratum"=>schedule_billing.stratum,
          "basic_charge_price"=>schedule_billing.basic_charge_price,
          "top_limit"=>schedule_billing.top_limit,
          "basic_price"=>schedule_billing.basic_price,
          "extra_price"=>schedule_billing.extra_price,
          "billing_frequency"=>schedule_billing.billing_frequency,
          "billing_period"=>schedule_billing.billing_period,
          "cut_day"=>schedule_billing.cut_day,
          "start_date"=>"2019-08-22",
        },
        "schedule_report"=> {
          "email"=>schedule_report.email,
          "frequency_day"=>schedule_report.frequency_day,
          "frequency_interval"=>schedule_report.frequency_interval,
          "start_date"=>"2019-08-22",
        }
      }

      expect(subject).to match(expected_response)
    end
  end
end
