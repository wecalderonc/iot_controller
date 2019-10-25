require 'rails_helper'

RSpec.describe Alarm, type: :model do

  it { is_expected.to define_property :value, :String }
  it { is_expected.to define_property :viewed_date, :Date}
  it { is_expected.to define_property :viewed, :Boolean}
  it { is_expected.to have_one(:uplink).with_direction(:out) }
  it { is_expected.to have_one(:alarm_type).with_direction(:out) }

  describe "Validations" do
    it "date and value are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :value=>["can't be blank"]
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end

  describe "#last_digit" do
    let(:alarm) { create(:alarm, value: "0002") }

    it "return last digit of value" do
      expect(alarm.last_digit).to eq(2)
    end
  end

  describe "#last_power_connection_alarm" do
    let(:thing) { create(:thing) }
    let(:uplink) { create(:uplink, thing: thing )}
    let(:uplink2) { create(:uplink, thing: thing )}
    let(:uplink3) { create(:uplink, thing: thing )}

    context "thing has alarms with 0001 value" do
      it "return alarms with 0001 value" do
        alarm = create(:alarm, value: "0001", created_at: DateTime.new(2019,10,1), uplink: uplink)
        alarm2 = create(:alarm, value: "0002", created_at: DateTime.new(2019,10,2), uplink: uplink2)
        alarm3 = create(:alarm, value: "0001", created_at: DateTime.new(2019,10,3), uplink: uplink3)
        alarms = thing.uplinks.alarm
        response = Alarm.last_power_connection_alarm(alarms)

        expect(response).to eq(alarm3)
      end
    end

    context "thing does not have alarms" do
      it "return nil" do
        alarms = thing.uplinks.alarm
        response = Alarm.last_power_connection_alarm(alarms)

        expect(response).to eq(nil)
      end
    end

    context "thing does not have alarms with 0001 value" do
      it "return nil" do
        alarm = create(:alarm, value: "0003", created_at: DateTime.new(2019,10,1), uplink: uplink)
        alarm2 = create(:alarm, value: "0002", created_at: DateTime.new(2019,10,2), uplink: uplink2)
        alarm3 = create(:alarm, value: "0002", created_at: DateTime.new(2019,10,3), uplink: uplink3)
        alarms = thing.uplinks.alarm
        response = Alarm.last_power_connection_alarm(alarms)

        expect(response).to eq(nil)
      end
    end
  end
end
