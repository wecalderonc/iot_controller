require 'rails_helper'

RSpec.describe ScheduleBilling, :type => :model do

  it { is_expected.to define_property :stratum, :Integer }
  it { is_expected.to define_property :basic_charge, :Float }
  it { is_expected.to define_property :top_limit, :Float }
  it { is_expected.to define_property :basic_price, :Float }
  it { is_expected.to define_property :extra_price, :Float }
  it { is_expected.to define_property :billing_frequency, :Integer }
  it { is_expected.to define_property :billing_period, :String }
  it { is_expected.to define_property :cut_day, :Integer }
  it { is_expected.to define_property :start_date, :String }

  it { is_expected.to have_one(:location).with_direction(:out) }

  describe "Validations" do
    it "all properties are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :stratum=>["can't be blank"],
        :basic_charge=>["can't be blank"],
        :top_limit=>["can't be blank"],
        :basic_price => ["can't be blank"],
        :extra_price => ["can't be blank"],
        :billing_frequency=>["can't be blank"],
        :billing_period=>["can't be blank"],
        :cut_day=>["can't be blank"],
        :start_date=>["can't be blank"],
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end
end
