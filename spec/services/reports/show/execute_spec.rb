require 'rails_helper'

RSpec.describe Reports::Show::Execute do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:billing)  { create(:schedule_billing, billing_frequency: 1, start_date: DateTime.now - (3.months + 22.days)) }
    let(:location) { create(:location, schedule_billing: billing) }
    let(:thing)    { create(:thing, units: { liter: 200 }, locates: location) }
    let(:uplink)   { create(:uplink, thing: thing, time: (Time.now - 1.month).to_i) }
    let(:uplink2)  { create(:uplink, thing: thing, time: (Time.now - 2.months).to_i) }
    let(:uplink3)  { create(:uplink, thing: thing, time: (Time.now - 3.months).to_i) }
    let(:uplink4)  { create(:uplink, thing: thing, time: (Time.now - 2.days).to_i ) }
    let!(:price)   { create(:price) }
    let(:input)    { { params: { thing_name: thing.name }, model: :accumulator, thing: Thing, option: :csv_format } }

    context "There are things with objects related" do
      let!(:accumulator1) { create(:accumulator, value: "100", uplink: uplink4) }
      let!(:accumulator2) { create(:accumulator, value: "110", uplink: uplink3) }
      let!(:accumulator3) { create(:accumulator, value: "120", uplink: uplink2) }
      let!(:accumulator4) { create(:accumulator, value: "130", uplink: uplink) }

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

          expect(response).to be_success
          expect(response.success[:thing_id]).to eq(thing.id)
          expect(response.success[:thing_name]).to eq(thing.name)
          expect(response.success[:accumulators].count).to eq(4)
        end
      end

      context "historical and projected consumption" do
        it "Should return a hash with billing periods and projected consumption" do
          input[:option] = :json_format
          start_date = Date.today - 22.days
          end_date = Date.today

          historical_response = {
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

          projected_response = {
            value: 69818.18181818182,
            days_count: 8
          }

          expect(response).to be_success
          expect(response.success.keys.count).to eq(5)
          expect(response.success[:thing_id]).to eq(thing.id)
          expect(response.success[:thing_name]).to eq(thing.name)
          expect(response.success[:accumulators].count).to eq(4)
          expect(response.success[:consumptions_by_month].keys.count).to eq(4)
          expect(response.success[:consumptions_by_month]).to match(historical_response)
          expect(response.success[:projected_consumption]).to match(projected_response)
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
