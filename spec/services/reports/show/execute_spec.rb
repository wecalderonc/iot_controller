require 'rails_helper'

RSpec.describe Reports::Show::Execute do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:thing)    { create(:thing) }
    let(:uplink2)  { create(:uplink, thing: thing) }
    let(:uplink)   { create(:uplink, thing: thing) }
    let(:input)    { { params: { thing_name: thing.name }, model: :accumulator, thing: Thing, option: :csv_format } }

    context "There are things with objects related" do
      let!(:accumulator1) { create(:accumulator, value: "00006fff", uplink: uplink) }
      let!(:accumulator2) { create(:accumulator, value: "00008fff", uplink: uplink2) }

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

          date1 = uplink.created_at.strftime('%a %d %b %Y')
          date2 = uplink2.created_at.strftime('%a %d %b %Y')

          result = response.success[0]

          expect(response).to be_success
          expect(result[:thing_id]).to eq(thing.id)
          expect(result[:thing_name]).to eq(thing.name)
          expect(result[:accumulators].count).to eq(2)
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
