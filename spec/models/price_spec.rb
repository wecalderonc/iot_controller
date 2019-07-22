require 'rails_helper'

RSpec.describe Price, type: :model do
  it { is_expected.to define_property :unit, :String }
  it { is_expected.to define_property :value, :Float }
  it { is_expected.to define_property :date, :Date }
  it { is_expected.to define_property :currency, :String }

  describe "Validations" do
    it "all attributes are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :currency=>["can't be blank"],
        :date=>["can't be blank"],
        :value=>["can't be blank"],
        :unit=>["can't be blank"]
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end
end
