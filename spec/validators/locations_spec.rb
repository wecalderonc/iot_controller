require 'rails_helper'

RSpec.describe Validators::Locations do
  describe 'CreateSchema' do
    let(:user)    { create(:user, email: "user@gmail.com") }
    let(:thing)   { create(:thing) }
    let(:country) { create(:country, code_iso: 'CO') }
    let(:state)   { create(:state, code_iso: 'CO-DC', country: country) }
    let(:city)    { create(:city, name: 'Bogota', state: state) }
    let(:response) { described_class::CreateSchema.(input) }

    let(:input) {
      { thing_name: thing.name,
        location: {
          name: 'My house',
          address: 'Carrera 7 # 71 - 21',
          latitude: 4.606880,
          longitude: -74.071840
        },
        country_state_city: {
          country: 'CO',
          state: 'CO-DC',
          city: city.name
        },
        schedule_billing: {
          stratum: 5,
          basic_charge: 13.841,
          top_limit: 40.0,
          basic_price: 2.000,
          extra_price: 2.500,
          billing_frequency: 2,
          billing_period: 'month',
          cut_day: 10,
          start_day: 10,
          start_month: 10,
          start_year: 2019
        },
        schedule_report: {
          email: 'unacosita@gmail.com',
          frequency_day: 1,
          frequency_interval: 'week',
          start_day: 10,
          start_month: 10,
          start_year: 2019
        }
      }
    }
    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:thing_name] = 12345

        expected_response = {
          :thing_name => ["must be String"]
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:location][:name] = 12345

        expected_response = {
          :location => {
            :name => ["must be String"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:location][:address] = 12345

        expected_response = {
          :location => {
            :address => ["must be String"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:location][:latitude] = "123456"

        expected_response = {
          :location => {
            :latitude => ["must be Float"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:location][:latitude] = 1234.56

        expected_response = {
          :invalid_latitude => ["Wrong latitude"]
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:location][:latitude] = -92.0

        expected_response = {
          :invalid_latitude => ["Wrong latitude"]
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:location][:longitude] = 12345

        expected_response = {
          :location => {
            :longitude => ["must be Float"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:location][:longitude] = 1234.56

        expected_response = {
          :invalid_longitude => ["Wrong longitude"]
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:location][:longitude] = -182.0

        expected_response = {
          :invalid_longitude => ["Wrong longitude"]
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:country_state_city][:country] = 12345

        expected_response = {
          :country_state_city => {
            :country => ["must be String"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:country_state_city][:state] = 12345

        expected_response = {
          :country_state_city => {
            :state => ["must be String"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:country_state_city][:state] = Faker::String.random(length: 54)

        expected_response = {
          :country_state_city => {
            :state => ["size cannot be greater than 50"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:country_state_city][:city] = 12345

        expected_response = {
          :country_state_city => {
            :city => ["must be String"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:country_state_city][:city] = Faker::String.random(length: 54)

        expected_response = {
          :country_state_city => {
            :city => ["size cannot be greater than 50"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:stratum] = "12345"

        expected_response = {
          :schedule_billing => {
            :stratum => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:basic_charge] = "12345"

        expected_response = {
          :schedule_billing => {
            :basic_charge => ["must be Float"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:basic_charge] = -1.0

        expected_response = {
            :invalid_basic_charge => ["The value must be positive"]
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:top_limit] = "12345"

        expected_response = {
          :schedule_billing => {
            :top_limit => ["must be Float"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:basic_price] = "12345"

        expected_response = {
          :schedule_billing => {
            :basic_price => ["must be Float"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:extra_price] = "12345"

        expected_response = {
          :schedule_billing => {
            :extra_price => ["must be Float"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:billing_frequency] = "12345"

        expected_response = {
          :schedule_billing => {
            :billing_frequency => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:billing_period] = 12345

        expected_response = {
          :schedule_billing => {
            :billing_period => ["must be String"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:billing_period] = 'jaja'

        expected_response = {
          :invalid_period => ["Wrong period"]
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:cut_day] = "12345"

        expected_response = {
          :schedule_billing => {
            :cut_day => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:cut_day] = 42

        expected_response = {
          :schedule_billing => {
            :cut_day => ["must be less than or equal to 30"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:start_day] = "12345"

        expected_response = {
          :schedule_billing => {
            :start_day => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:start_day] = 40  

        expected_response = {
          :schedule_billing => {
            :start_day => ["must be less than or equal to 30"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:start_month] = "12345"

        expected_response = {
          :schedule_billing => {
            :start_month => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:start_month] = 14

        expected_response = {
          :schedule_billing => {
            :start_month => ["must be less than or equal to 12"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_billing][:start_year] = "12345"

        expected_response = {
          :schedule_billing => {
            :start_year => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_report][:email] = 12345

        expected_response = {
          :schedule_report => {
            :email => ["must be String"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_report][:email] = "estonisiquieraesuncorreo.aja"

        expected_response = {
          :schedule_report => {
            :email => ["is in invalid format"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_report][:frequency_day] = "12345"

        expected_response = {
          :schedule_report => {
            :frequency_day => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_report][:frequency_interval] = 12345

        expected_response = {
          :schedule_report => {
            :frequency_interval => ["must be String"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_report][:frequency_interval] = 'jaja'

        expected_response = {
          :invalid_interval => ["Wrong interval"]
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_report][:start_day] = "12345"

        expected_response = {
          :schedule_report => {
            :start_day => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_report][:start_month] = "12345"

        expected_response = {
          :schedule_report => {
            :start_month => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the 'validation' operation fails" do
      it "Should return a Failure response" do
        input[:schedule_report][:start_year] = "12345"

        expected_response = {
          :schedule_report => {
            :start_year => ["must be Integer"]
          }
        }

        expect(response.failure?).to be_truthy
        expect(response.errors).to eq(expected_response)
      end
    end

    context "When the validation is successful" do
      let(:location) { thing.locates }
      let(:schedule_billing) { location.schedule_billing }
      let(:schedule_report) { location.schedule_report }

      it "Should return a Success response" do
        expect(response.success?).to be_truthy
        expect(response.output).to match(input)
      end
    end
  end
end
