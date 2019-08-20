require 'rails_helper'

RSpec.describe Things::BatteryLevels::Get do
  describe '#call' do
    let(:response) { subject.(input) }

    context 'thing has battery_level history' do
      let(:battery_level) { create(:battery_level, value: "0001") }
      let(:thing) { battery_level.uplink.thing }
      let!(:input) { { thing: thing } }

      it 'should return success response' do

        expect(response).to be_success
        expect(response.success[:batteries].count).to match(1)
        expect(response.success[:batteries][0].value).to match("0001")
      end
    end

    context 'thing does not have battery level history' do
      let(:thing2) { create(:thing) }
      let(:input) { { thing: thing2 } }

      it 'should return failure response' do

        expect(response).to be_failure
        expect(response.failure[:message]).to eq('The thing  does not have battery level history')
      end
    end
  end
end
