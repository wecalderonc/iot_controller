require 'rails_helper'

RSpec.describe ValveTransition, type: :model do

  it { is_expected.to define_property :real_state, :String }
  it { is_expected.to define_property :showed_state, :String }
  it { is_expected.to have_one(:thing).with_direction(:in) }

  describe "Validations" do

    context "real and showed state are wrong" do
      let(:valve_transition) { build(:valve_transition, real_state: "wrong", showed_state: "wrong") }

      it "real and showed state are invalid" do
        expect(valve_transition).to_not be_valid

        expected_errors = {
         :showed_state => ["is not included in the list"],
         :real_state => ["is not included in the list"]
        }

        expect(valve_transition.errors.messages).to eq(expected_errors)
      end
    end

    context "real and showed state are integer" do
      let(:valve_transition) { build(:valve_transition, real_state: 123456, showed_state: 123456) }

      it "real and showed state are invalid" do
        expect(valve_transition).to_not be_valid

        expected_errors = {
         :showed_state => ["is not included in the list"],
         :real_state => ["is not included in the list"]
        }

        expect(valve_transition.errors.messages).to eq(expected_errors)
      end
    end

    context "real and showed state are open" do
      let(:valve_transition) { build(:valve_transition, real_state: "open", showed_state: "open") }

      it "real and showed state are valid" do
        expect(valve_transition).to be_valid
      end
    end

    context "real and showed state are closed" do
      let(:valve_transition) { build(:valve_transition, real_state: "closed", showed_state: "closed") }

      it "state is valid" do
        expect(valve_transition).to be_valid
      end
    end

    context "showed state is closing" do
      let(:valve_transition) { build(:valve_transition, showed_state: "closing") }

      it "state is valid" do
        expect(valve_transition).to be_valid
      end
    end

    context "showed_state is opening" do
      let(:valve_transition) { build(:valve_transition, showed_state: "opening") }

      it "state is valid" do
        expect(valve_transition).to be_valid
      end
    end

    context "real state and showed_state are not_detected" do
      let(:valve_transition) { build(:valve_transition, real_state: "not_detected", showed_state: "not_detected") }

      it "state is valid" do
        expect(valve_transition).to be_valid
      end
    end

    context "real_state is opening" do
      let(:valve_transition) { build(:valve_transition, real_state: :awaiting_downlink) }

      it "real_state is valid" do
        expect(valve_transition).to be_valid
      end
    end

    context "real_state is opening" do
      let(:valve_transition) { build(:valve_transition, real_state: :awaiting_open) }

      it "real_state is valid" do
        expect(valve_transition).to be_valid
      end
    end

    context "real_state is opening" do
      let(:valve_transition) { build(:valve_transition, real_state: :awaiting_closed) }

      it "real_state is valid" do
        expect(valve_transition).to be_valid
      end
    end
  end
end

