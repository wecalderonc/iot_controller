require 'rails_helper'

RSpec.describe Reports::Index::Execute do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:uplink2)  { create(:uplink) }
    let(:uplink)   { create(:uplink) }
    let(:thing)    { uplink.thing }
    let(:thing2)   { uplink2.thing }
    let(:input)    { { params: {}, model: :accumulator, thing: Thing, option: :csv_format } }

    context "There are things with accumulators related" do
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

          accumulator1_response = {
            :thing_id => thing.id,
            :thing_name =>thing.name,
            :accumulators => [{
              :date => date1,
              :value => accumulator1.value,
              :consumption_delta => accumulator1.value.to_i(16),
              :accumulated_delta => accumulator1.value.to_i(16)
            }]
          }

          accumulator2_response = {
            :thing_id => thing2.id,
            :thing_name =>thing2.name,
            :accumulators => [{
              :date => date2,
              :value => accumulator2.value,
              :consumption_delta => accumulator2.value.to_i(16),
              :accumulated_delta => accumulator2.value.to_i(16)
            }]
          }

          expect(response).to be_success
          expect(response.success.count).to eq(2)
          expect(response.success).to include(accumulator1_response)
          expect(response.success).to include(accumulator2_response)
        end
      end
    end
  end
end