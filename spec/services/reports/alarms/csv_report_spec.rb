require 'rails_helper'

RSpec.describe Reports::Alarms::CsvReport do
  describe "#call" do
    let(:input)   { { objects: ThingsQuery.new.sort_alarms, model: :alarm } }
    let(:response) { subject.(input) }

    it "should return a csv file with thing's alarms data"do
      alarm = create :alarm

      uplink = alarm.uplink
      thing = uplink.thing
      date = uplink.created_at.strftime('%a %d %b %Y')

      expect(response).to include("BD ID,ID Dispositivo,Fecha/Hora,Valor Alarma")
      expect(response).to include("#{thing.name}")
      expect(response).to include("#{thing.id}")
      expect(response).to include("#{date}")
    end
  end
end
