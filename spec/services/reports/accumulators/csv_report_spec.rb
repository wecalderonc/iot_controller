require 'rails_helper'

RSpec.describe Reports::Accumulators::CsvReport do
  describe "#call" do
    let(:input)    { ThingsQuery.new.sort_accumulators }
    let(:response) { subject.(input) }

    it "should return a csv file with thing's accumulators data"do
      accumulator = create :accumulator

      uplink = accumulator.uplink
      thing = uplink.thing
      date = uplink.created_at.strftime('%a %d %b %Y')

      expect(response).to include("BD ID,ID Dispositivo,Fecha/Hora,Valor Acumulador,Delta Consumo,Delta Acumulado")
      expect(response).to include("#{thing.name}")
      expect(response).to include("#{thing.id}")
      expect(response).to include("#{date}")
    end
  end
end
