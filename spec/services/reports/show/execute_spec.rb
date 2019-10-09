require 'rails_helper'

RSpec.describe Reports::Show::Execute do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - (4.months - 8.days)) }
    let(:location) { create(:location, schedule_billing: billing) }
    let(:thing)    { create(:thing, locates: location) }
    let(:uplink)   { create(:uplink, thing: thing, time: (Time.now - 1.month).to_i) }
    let(:uplink2)  { create(:uplink, thing: thing, time: (Time.now - 2.months).to_i) }
    let(:uplink3)  { create(:uplink, thing: thing, time: (Time.now - 3.months).to_i) }
    let(:uplink4)  { create(:uplink, thing: thing, time: (Time.now - (Time.now -  + 2.days).to_i)) }
    let(:input)    { { params: { thing_name: thing.name }, model: :accumulator, thing: Thing, option: :csv_format } }

    context "There are things with objects related" do
      let!(:accumulator1) { create(:accumulator, value: "10", uplink: uplink) }
      let!(:accumulator2) { create(:accumulator, value: "20", uplink: uplink2) }
      let!(:accumulator3) { create(:accumulator, value: "10", uplink: uplink3) }
      let!(:accumulator4) { create(:accumulator, value: "30", uplink: uplink4) }

      context "CSV format" do
        it "Should return a Success response" do
          expect(response).to be_success
          expect(response.success).to include("BD ID,ID Dispositivo,Fecha/Hora,Valor Acumulador,Delta Consumo,Delta Acumulado")
          expect(response.success).to include("#{thing.name}")
          expect(response.success).to include("#{thing.id}")
        end
      end

      context "JSON format" do
        it "Should return a Success response" do
          input[:option] = :json_format

          result = response.success[0]

          expect(response).to be_success
          expect(result[:thing_id]).to eq(thing.id)
          expect(result[:thing_name]).to eq(thing.name)
          expect(result[:accumulators].count).to eq(4)
        end
      end

      context "historical consumption" do
        context "two months" do
          it "Should return a hash with billing periods" do
            input[:option] = :json_format

            expected_response = {
              thing_name: thing.name,
              consumption_by_period: [
                {
                  '1': {
                    delta_accumulated: 0,
                    days_quantity: 30,
                    months: [ (Time.now - 4.months).month ]
                  },
                  '2': {
                    delta_accumulated: 16,
                    days_quantity: 30,
                    months: [ (Time.now - 3.months).month ]
                  },
                  '3': {
                    delta_accumulated: 32,
                    days_quantity: 30,
                    months: [ (Time.now - 2.months).month ]
                  },
                  '4': {
                    delta_accumulated: 32,
                    days_quantity: 22,
                    months: [ [(Time.now - 1.month).month, Time.now.month] ]
                  }
                }
              ]
            }

            result = response.success[0]
            puts "*" * 100
            p response.success
            puts "*" * 100
           
            expect(response).to be_success
            expect(result[:thing_id]).to eq(thing.id)
            expect(result[:thing_name]).to eq(thing.name)
            expect(result[:accumulators].count).to eq(4)
            expect(result[:consumption_by_period].keys.count).to eq(4)
            expect(result[:consumption_by_period]).to eq(expected_response)
          end
        end

        context "one month" do
        end
      end
    end

    context "thing_name is missing" do
      it "should return a Failure response" do
       input[:params].delete(:thing_name)

        response = subject.(input)
        expected_response = {
          :params => {
            :thing_name => ["is missing"]
          }
        }

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end

    context "start_date is in invalid format" do
      it "should return a Failure response" do
        input[:params][:date] =  { start_date: 1234 }

        expected_response = {
          :params => {
            :date => {
              :start_date => ["must be String"],
              :end_date => ["is missing"]
            }
          }
        }

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end

    context "end_date is in invalid format" do
      it "should return a Failure response" do
        input[:params][:date] =  { end_date: 1234 }

        expected_response = {
          :params => {
            :date => {
              :start_date => ["is missing"],
              :end_date => ["must be String"]
            }
          }
        }

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end

    context "invalid thing_name" do
      it "should return a Failure response" do
        input[:params][:thing_name] = "invalid_name"

        response = subject.(input)
        expected_response = "The thing invalid_name does not exist"

        expect(response).to be_failure
        expect(response.failure[:message]).to eq(expected_response)
      end
    end
  end
end
