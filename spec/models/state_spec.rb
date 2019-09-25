require 'rails_helper'

RSpec.describe State, :type => :model do

  it { is_expected.to define_property :name, :String }
  it { is_expected.to define_property :code_iso, :String }

  it { is_expected.to have_many(:cities).with_direction(:out) }
  it { is_expected.to have_one(:country).with_direction(:in) }

  describe "Validations" do
    it "name and code_iso are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :name=>["can't be blank"],
        :code_iso=>["can't be blank"],
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end
end
