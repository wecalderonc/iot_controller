require 'rails_helper'

RSpec.describe Locations::Create::Execute do
  describe "#call" do
    let(:response) { subject.(input) }

    context "When the user is creating a new location" do
      let(:user)    { create(:user, email: "user@gmail.com") }
      let(:thing)   { create(:thing) }
      let(:country) { create(:country, code_iso: 'CO') }

      let(:input) {
        { thing_id: thing.id,
          location: {
            name: 'My house',
            address: 'Carrera 7 # 71 - 21',
            latitude: '4.606880',
            longitude: '-74.071840'
          },
          country_state_city: {
            country: 'Colombia',
            state: 'Bogota DC',
            city: 'Bogota'
          },
          schedule_billing: {
            stratum: 5,
            basic_charge: 13.841,
            top_limit: 40,
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
            frequency_day: 'monday',
            frequency_interval: 'week',
            start_day: 10,
            start_month: 10,
            start_year: 2019
          }
        }
      }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          expect(response).to be_success
          expect(response.success).to match(input)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:thing_id] = 12345

          expected_response = {
            :thing_id => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:location][:name] = 12345

          expected_response = {
            :name => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:location][:address] = 12345

          expected_response = {
            :address => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:location][:latitude] = "123456"

          expected_response = {
            :latitude => ["must be Float"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:location][:latitude] = 1234.56

          expected_response = {
            :latitude => ["ojo pues"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:location][:latitude] = -12

          expected_response = {
            :latitude => ["ojo pues"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:location][:longitude] = 12345

          expected_response = {
            :longitude => ["must be Float"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:location][:longitude] = 1234.56

          expected_response = {
            :longitude => ["ojo pues"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:location][:longitude] = -12

          expected_response = {
            :longitude => ["ojo pues"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:country_state_city][:country] = 12345

          expected_response = {
            :country => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:country_state_city][:state] = 12345

          expected_response = {
            :state => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:country_state_city][:state] = 'estaesunpaismuylargoynodeberiaserasi123456'

          expected_response = {
            :state => ["ojo pues"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:country_state_city][:city] = 12345

          expected_response = {
            :city => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:country_state_city][:city] = 'estaesunaciudadmuylargaynodeberiaserasi123456'

          expected_response = {
            :city => ["ojo pues"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:stratum] = "12345"

          expected_response = {
            :stratum => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:basic_charge] = "12345"

          expected_response = {
            :basic_charge => ["must be Float"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:basic_charge] = -1

          expected_response = {
            :basic_charge => ["ojo pues"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:top_limit] = "12345"

          expected_response = {
            :top_limit => ["must be Float"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:basic_price] = "12345"

          expected_response = {
            :basic_price => ["must be Float"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:extra_price] = "12345"

          expected_response = {
            :extra_price => ["must be Float"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:billing_frequency] = "12345"

          expected_response = {
            :billing_frequency => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:billing_period] = 12345

          expected_response = {
            :billing_period => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:cut_day] = "12345"

          expected_response = {
            :cut_day => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:start_day] = "12345"

          expected_response = {
            :start_day => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:start_month] = "12345"

          expected_response = {
            :start_month => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_billing][:start_year] = "12345"

          expected_response = {
            :start_year => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_report][:email] = 12345

          expected_response = {
            :email => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_report][:email] = "estonisiquieraesuncorreo.aja"

          expected_response = {
            :email => ["ojo pues"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_report][:frequency_day] = 12345

          expected_response = {
            :frequency_day => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_report][:frequency_interval] = 12345

          expected_response = {
            :frequency_interval => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_report][:start_day] = "12345"

          expected_response = {
            :start_day => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_report][:start_month] = "12345"

          expected_response = {
            :start_month => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:schedule_report][:start_year] = "12345"

          expected_response = {
            :start_year => ["must be Integer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When country is wrong" do
        it "Should return a Failure response" do
          input[:country_state_city][:country] = "invalid_code"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq("Country not found")
        end
      end

      context "When state is wrong" do
        it "Should return a Failure response" do
          input[:country_state_city][:state] = "invalid_code"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq("State not found")
        end
      end

      context "When city is wrong" do
        it "Should return a Failure response" do
          input[:country_state_city][:city] = "invalid_name"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq("City not found")
        end
      end

      context "When the 'get' operation fails" do
        it "Should return a Failure response" do
          input[:thing_id] = "invalid_id"

          expected_response = "Device not found"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
