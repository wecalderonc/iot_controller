require 'rails_helper'

RSpec.describe Things::AccumulatorsReport do
  describe "#call" do
    let(:data)   { ThingsQuery.new.sort_accumulators }
    let(:result) { described_class.(data) }

    it "should return a csv file with thing's accumulators data"do
      accumulator = create :accumulator

      uplink = accumulator.uplink
      thing =  uplink.thing
      date =   uplink.created_at.strftime('%a %d %b %Y')

      expect(result).to include("BD ID,ID Dispositivo,Fecha/Hora,Valor Acumulador,Delta Consumo,Delta Acumulado")
      expect(result).to include("#{thing.name}")
      expect(result).to include("#{thing.id}")
      expect(result).to include("#{date}")
    end
  end
end
