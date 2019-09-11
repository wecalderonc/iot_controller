require 'rails_helper'

RSpec.describe ValveState, type: :model do

  it { is_expected.to define_property :state, :String }
  it { is_expected.to have_one(:thing).with_direction(:in) }

  describe "Validations" do
    it "state is required" do
      expect(subject).to_not be_valid

      expected_errors = {
       :state => ["can't be blank", "is not included in the list"]
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end

    context "state is wrong" do
      let(:valve_state) { build(:valve_state, state: "wrong") }

      it "state is invalid" do
        expect(valve_state).to_not be_valid

        expected_errors = {
         :state => ["is not included in the list"]
        }

        expect(valve_state.errors.messages).to eq(expected_errors)
      end
    end

    context "state is integer" do
      let(:valve_state) { build(:valve_state, state: 123456) }

      it "state is invalid" do
        expect(valve_state).to_not be_valid

        expected_errors = {
         :state => ["is not included in the list"]
        }

        expect(valve_state.errors.messages).to eq(expected_errors)
      end
    end

    context "state is open" do
      let(:valve_state) { build(:valve_state, state: "open") }

      it "state is valid" do
        expect(valve_state).to be_valid
      end
    end

    context "state is closed" do
      let(:valve_state) { build(:valve_state, state: "closed") }

      it "state is valid" do
        expect(valve_state).to be_valid
      end
    end

    context "state is closing_process" do
      let(:valve_state) { build(:valve_state, state: "closing_process") }

      it "state is valid" do
        expect(valve_state).to be_valid
      end
    end

    context "state is opening_process" do
      let(:valve_state) { build(:valve_state, state: "opening_process") }

      it "state is valid" do
        expect(valve_state).to be_valid
      end
    end

    context "state is not_detected" do
      let(:valve_state) { build(:valve_state, state: "not_detected") }

      it "state is valid" do
        expect(valve_state).to be_valid
      end
    end
  end
end

