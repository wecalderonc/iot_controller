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
end
