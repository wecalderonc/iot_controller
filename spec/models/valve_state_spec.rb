require 'rails_helper'

RSpec.describe ValveState, type: :model do

  it { is_expected.to define_property :state, :String }
  it { is_expected.to have_one(:thing).with_direction(:in) }

  describe "Validations" do
    it "state is required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :state=>["can't be blank"]
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end
end

