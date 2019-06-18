require 'rails_helper'

RSpec.describe Thing, :type => :model do

  describe "Validations" do
    it "email and password are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :name=>["can't be blank"],
        :status=>["can't be blank"],
        :pac=>["can't be blank"],
        :company_id=>["can't be blank"],
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end

  it { is_expected.to define_property :name, :String }
  it { is_expected.to define_property :status, :String }
  it { is_expected.to define_property :pac, :String }
  it { is_expected.to define_property :company_id, :String }

  it { is_expected.to have_one(:uplinks).with_direction(:out) }
end
