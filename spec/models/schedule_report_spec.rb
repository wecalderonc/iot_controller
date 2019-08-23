require 'rails_helper'

RSpec.describe ScheduleReport, :type => :model do

  it { is_expected.to define_property :email, :String }
  it { is_expected.to define_property :frequency_day, :Integer }
  it { is_expected.to define_property :frequency_interval, :String }
  it { is_expected.to define_property :start_date, :String }

  it { is_expected.to have_one(:location).with_direction(:out) }

  describe "Validations" do
    it "email and password are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :email=>["can't be blank"],
        :start_date => ["can't be blank"],
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end
end
