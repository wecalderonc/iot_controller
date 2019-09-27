require 'rails_helper'

RSpec.describe Reports::Accumulators::Index::Execute do
  describe '#call' do
    let(:response) { subject.(input) }
    let(:uplink)   { create(:uplink) }
    let(:thing)    { uplink.thing }
    let(:input)    { { params: {}, model: :accumulator, thing: Thing } }

    context "There are things with accumulators related" do
      it "Should return a Success response" do
        accumulator1 = create(:accumulator, value: "00006fff", uplink: uplink)
        accumulator2 = create(:accumulator, value: "00007fff", uplink: uplink)
        accumulator3 = create(:accumulator, value: "00008fff", uplink: uplink)

        expect(response).to be_success
        expect(response.success).to include("BD ID,ID Dispositivo,Fecha/Hora,Valor Acumulador,Delta Consumo,Delta Acumulado")
        expect(response.success).to include("4096")
        expect(response.success).to include("#{thing.name}")
        expect(response.success).to include("#{thing.id}")
      end
    end

    context "There aren't things with accumulators related" do
      it "Should return a Failure response" do
        expect(response).to be_failure
        expect(response.failure[:message]).to eq("Results not found")
        expect(response.failure[:code]).to eq(10104)
      end
    end
  end
end
