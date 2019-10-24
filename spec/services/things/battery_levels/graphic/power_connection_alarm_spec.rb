require 'rails_helper'

RSpec.describe Things::BatteryLevels::Graphic::PowerConnectionAlarm do
  describe '#call' do
    let(:response) { subject.(input) }

    context 'thing has alarm history' do
      context 'thing has upward transition' do
        let(:thing) { create(:thing) }
        let(:uplink) { create(:uplink, thing: thing )}
        let(:uplink2) { create(:uplink, thing: thing )}
        let(:uplink3) { create(:uplink, thing: thing )}
        let!(:alarm) { create(:alarm, value: "0001", created_at: DateTime.new(2019,10,1), uplink: uplink)}
        let!(:alarm2) { create(:alarm, value: "0002", created_at: DateTime.new(2019,10,2), uplink: uplink2)}
        let!(:alarm3) { create(:alarm, value: "0001", created_at: DateTime.new(2019,10,3), uplink: uplink3)}

        let!(:input) {
          {
            thing: thing
          }
        }

        it 'should return the most recent alarm with value 0001' do
          expect(response[:last_power_connection_alarm]).to match(alarm3)
        end
      end

      context 'thing doesnt have alarm with 0001 value' do
        let(:thing) { create(:thing) }
        let(:uplink) { create(:uplink, thing: thing )}

        let!(:input) {
          {
            thing: thing
          }
        }

        it 'should return array with battery levels' do
          expect(response[:last_power_connection_alarm]).to match(nil)
        end
      end

      context 'thing doesnt have alarms' do
        let(:thing) { create(:thing) }
        let(:uplink) { create(:uplink, thing: thing )}

        let!(:input) {
          {
            thing: thing
          }
        }

        it 'should return array with battery levels' do
          expect(response[:last_power_connection_alarm]).to match(nil)
        end
      end
    end
  end
end
