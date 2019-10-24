require 'rails_helper'

RSpec.describe Things::BatteryLevels::Graphic::Upward do
  describe '#call' do
    let(:response) { subject.(input) }

    context 'thing has battery_level history' do
      context 'thing has upward transition' do
        let(:thing) { create(:thing) }
        let(:uplink) { create(:uplink, thing: thing )}
        let!(:battery_level) { create(:battery_level, value: "0009", uplink: uplink, created_at: DateTime.new(2019,1,1)) }
        let!(:battery_level2) { create(:battery_level, value: "0009", uplink: uplink, created_at: DateTime.new(2019,1,2)) }
        let!(:battery_level3) { create(:battery_level, value: "0006", uplink: uplink, created_at: DateTime.new(2019,1,3)) }
        let!(:battery_level4) { create(:battery_level, value: "0003", uplink: uplink, created_at: DateTime.new(2019,1,4)) }
        let!(:battery_level5) { create(:battery_level, value: "0005", uplink: uplink, created_at: DateTime.new(2019,1,5)) }
        let!(:battery_level6) { create(:battery_level, value: "0004", uplink: uplink, created_at: DateTime.new(2019,1,6)) }

        let!(:input) {
          {
            thing: thing,
            batteries: thing.uplinks.batteryLevel
          }
        }

        it 'should return array with battery levels' do
          expect(response[:upward_transition]).to match(battery_level5)
        end
      end

      context 'thing doesnt have upward transition' do
        let(:thing) { create(:thing) }
        let(:uplink) { create(:uplink, thing: thing )}
        let!(:battery_level) { create(:battery_level, value: "0009", uplink: uplink, created_at: DateTime.new(2019,1,1)) }
        let!(:battery_level2) { create(:battery_level, value: "0008", uplink: uplink, created_at: DateTime.new(2019,1,2)) }
        let!(:battery_level3) { create(:battery_level, value: "0007", uplink: uplink, created_at: DateTime.new(2019,1,3)) }
        let!(:battery_level4) { create(:battery_level, value: "0006", uplink: uplink, created_at: DateTime.new(2019,1,4)) }
        let!(:battery_level5) { create(:battery_level, value: "0005", uplink: uplink, created_at: DateTime.new(2019,1,5)) }
        let!(:battery_level6) { create(:battery_level, value: "0004", uplink: uplink, created_at: DateTime.new(2019,1,6)) }

        let!(:input) {
          {
            thing: thing,
            batteries: thing.uplinks.batteryLevel
          }
        }

        it 'should return array with battery levels' do
          expect(response[:upward_transition]).to match({})
        end
      end
    end
  end
end
