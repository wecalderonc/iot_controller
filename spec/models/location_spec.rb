require 'rails_helper'

RSpec.describe Location, :type => :model do

  it { is_expected.to define_property :name, :String }
  it { is_expected.to define_property :address, :String }
  it { is_expected.to define_property :longitude, :Float }
  it { is_expected.to define_property :latitude, :Float }

  it { is_expected.to have_one(:city).with_direction(:out) }
  it { is_expected.to have_one(:schedule_report).with_direction(:out) }
  it { is_expected.to have_one(:schedule_billing).with_direction(:out) }

  it { is_expected.to have_many(:users).with_direction(:in) }

  describe "Validations" do
    it "name, address, longitude and latitude are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :name=>["can't be blank"],
        :address=>["can't be blank"],
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end
end
