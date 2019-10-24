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

  # describe "#classify" do
  #   let(:alarm) { create(:alarm, value: "0002") }

  #   it "return name of alarm_type 2" do
  #     expect(alarm.classify(2)).to eq(:induced_site_alarm)
  #   end

  #   it "return name of alarm_type 1" do
  #     expect(alarm.classify(1)).to eq(:power_connection)
  #   end

  #   it "return name of alarm_type 3" do
  #     expect(alarm.classify(3)).to eq(:sos)
  #   end

  #   it "return name of wrong alarm_type" do
  #     expect(alarm.classify(999)).to eq(:does_not_apply)
  #   end
  # end

  describe "#last_digit" do
    let(:alarm) { create(:alarm, value: "0002") }

    it "return last digit of value" do
      expect(alarm.last_digit).to eq(2)
    end
  end

  # describe "after_save" do
  #   let(:alarm) { build(:alarm, value: "0002") }

  #   it 'creates AlarmType and the relation with the Alarm' do
  #     expect { alarm.save }.to change { alarm.alarm_type.id }.from(nil).to be_truthy
  #   end
  # end
end
