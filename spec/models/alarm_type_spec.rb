require 'rails_helper'

RSpec.describe AlarmType, type: :model do

  it { is_expected.to define_property :value, :Integer }
  it { is_expected.to define_property :name, :String }
  it { is_expected.to define_property :type, :String }

  describe "Validations" do
    it "name, type and value are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :name=>["can't be blank"],
        :type=>["can't be blank"],
        :value=>["can't be blank"],
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end
end
