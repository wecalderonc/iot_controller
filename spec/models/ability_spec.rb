require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability do
  describe "abilities" do
    let(:user)          { create(:user) }
    let(:battery_level) { create(:battery_level) }
    let(:thing)         { battery_level.uplink.thing }
    let(:uplink)        { battery_level.uplink }
    let(:alarm)         { create(:alarm, uplink: uplink) }
    let(:accumulator)   { create(:accumulator, uplink: uplink) }
    let(:location)      { create(:location) }
    subject(:ability) { Ability.new(Dry::Monads::Result::Success.new(user)) }

    context "thing permissions" do
      context "when user is new, and doesnt have relations" do
        it "can manage it" do
          is_expected.to be_able_to(:read, Location)
          is_expected.to be_able_to(:create, Location)
        end

        it "cannot manage it " do
          is_expected.to_not be_able_to(:manage, location)
          is_expected.to_not be_able_to(:manage, thing)
          is_expected.to_not be_able_to(:manage, battery_level)
          is_expected.to_not be_able_to(:manage, alarm)
          is_expected.to_not be_able_to(:manage, accumulator)
        end
      end

      context "when user owns a thing" do
        it "can manage it" do
          Owner.create(from_node: user, to_node: thing)
          is_expected.to be_able_to(:manage, thing)
          is_expected.to be_able_to(:manage, alarm)
          is_expected.to be_able_to(:manage, battery_level)
          is_expected.to be_able_to(:manage, accumulator)
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

    context "locations permissions" do
      context "when user have locations -locates-" do
        context "user has a thing, and a location" do
          it "can manage it" do
            UserLocation.create(from_node: user, to_node: location)
            ThingLocation.create(from_node: thing, to_node: location)
            Owner.create(from_node: user, to_node: thing)

            is_expected.to be_able_to(:manage, location)
          end
        end

        context "user have locations but doesnt have things" do
          it "cannot manage it " do
            UserLocation.create(from_node: user, to_node: location)

            is_expected.to be_able_to(:manage, location)
          end
        end
      end

      context "when user doesn have location - locates-" do
        context "user doesnt have locations or things" do
          it "cannot manage it " do
            is_expected.to_not be_able_to(:manage, location)
          end
        end

        context "user doesnt have locations but the location has a thing related, and the user has the same thing related" do
          it "cannot manage it " do
            Owner.create(from_node: user, to_node: thing)
            ThingLocation.create(from_node: thing, to_node: location)

            is_expected.to_not be_able_to(:manage, location)
          end
        end
      end
    end
  end
end
