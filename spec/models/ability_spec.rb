require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability do
  describe "abilities" do
    let(:user)          { create(:user) }
    let(:battery_level) { create(:battery_level) }
    let(:thing)         { battery_level.uplink.thing }
    let(:uplink)        { battery_level.uplink }
    let(:alarm)         { create(:alarm, uplink: uplink) }
    subject(:ability) { Ability.new(Dry::Monads::Result::Success.new(user)) }

    #*************THINGS**************

    context "when user owns a thing" do
      it "can manage it" do
        Owner.create(from_node: user, to_node: thing)
        is_expected.to be_able_to(:manage, thing)
        is_expected.to be_able_to(:manage, alarm)
        is_expected.to be_able_to(:manage, battery_level)
      end
    end

    context "when user views a thing" do
      it "can read it" do
        Viewer.create(from_node: user, to_node: thing)
        is_expected.to be_able_to(:read, thing)
      end

      it "cannot manage it" do
        Viewer.create(from_node: user, to_node: thing)
        is_expected.to_not be_able_to(:manage, thing)
        is_expected.to_not be_able_to(:manage, battery_level)
        is_expected.to_not be_able_to(:manage, alarm)
      end
    end

    context "when user operates a thing" do
      it "can read it" do
        Operator.create(from_node: user, to_node: thing)
        is_expected.to be_able_to(:read, thing)
      end

      it "cannot manage it" do
        Operator.create(from_node: user, to_node: thing)
        is_expected.to_not be_able_to(:manage, thing)
        is_expected.to_not be_able_to(:manage, battery_level)
        is_expected.to_not be_able_to(:manage, alarm)
      end
    end
  end
end
