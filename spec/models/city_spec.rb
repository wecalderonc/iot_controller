require 'rails_helper'

RSpec.describe City, :type => :model do

  it { is_expected.to define_property :name, :String }

  it { is_expected.to have_one(:state).with_direction(:out) }

  describe "Validations" do
    it "name and code_iso are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :name=>["can't be blank"],
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end
end
