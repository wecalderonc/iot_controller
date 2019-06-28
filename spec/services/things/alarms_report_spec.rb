require 'rails_helper'

RSpec.describe Things::AlarmsReport do
  describe "#call" do
    let(:data)   { ThingsQuery.new.sort_alarms }
    let(:result) { described_class.(data) }

    it "should return a csv file with thing's alarms data"do
      alarm = create :alarm

      uplink = alarm.uplink
      thing = uplink.thing
      date = uplink.created_at.strftime('%a %d %b %Y')

      expect(result).to include("BD ID,ID Dispositivo,Fecha/Hora,Valor Alarma")
      expect(result).to include("#{thing.name}")
      expect(result).to include("#{thing.id}")
      expect(result).to include("#{date}")
    end
  end
end
