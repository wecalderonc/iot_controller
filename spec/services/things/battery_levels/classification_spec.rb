require 'rails_helper'

RSpec.describe Things::BatteryLevels::Classification do
  describe '#call' do
    let(:response) { subject.(input) }

    context 'thing has battery_level history' do
      context 'thing has correct level battery' do
        let(:battery_level) { create(:battery_level, value: "0001") }
        let(:thing) { battery_level.uplink.thing }
        let(:uplink2) { create(:uplink, thing: thing) }
        let!(:battery_level2) { create(:battery_level, value: "0002", uplink: uplink2) }

        let!(:input) { { batteries: thing.uplinks.batteryLevel.to_a } }

        it 'should return array with battery levels' do

          levels = response.pluck(:level_label).sort

          expect(response.count).to match(2)
          expect(levels).to match([:low, :middle_low])
        end
      end

      context 'thing has incorrect level battery' do
        let(:battery_level) { create(:battery_level, value: "000f") }
        let(:thing) { battery_level.uplink.thing }
        let(:uplink2) { create(:uplink, thing: thing) }
        let!(:battery_level2) { create(:battery_level, value: "000a", uplink: uplink2) }

        let!(:input) { { batteries: thing.uplinks.batteryLevel.to_a } }

        it 'should return array with battery levels' do

          levels = response.pluck(:level_label).sort

          expect(response.count).to match(2)
          expect(levels).to match([:does_not_apply, :does_not_apply])
        end
      end
    end
  end
end
