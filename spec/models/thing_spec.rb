require 'rails_helper'

RSpec.describe Thing, :type => :model do

  it { is_expected.to define_property :name, :String }
  it { is_expected.to define_property :status, :String }
  it { is_expected.to define_property :pac, :String }
  it { is_expected.to define_property :company_id, :String }

  it { expect(Thing.serialized_properties).to include({:coordinates=>{:type=>Array}}) }

  it { is_expected.to have_one(:uplinks).with_direction(:out) }

  it { is_expected.to have_many(:owner).with_direction(:in) }
  it { is_expected.to have_many(:operator).with_direction(:in) }
  it { is_expected.to have_many(:viewer).with_direction(:in) }

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

  describe "#last_accumulators" do
    let(:thing) { create(:thing) }

    context "When there are uplinks and accumulators" do
      it "Should return the last accumulator" do
        create(:uplink, thing: thing, created_at: Time.zone.now)
        create(:uplink, thing: thing, created_at: Time.zone.now + 1.minutes)

        uplink = create(:uplink, thing: thing, created_at: Time.zone.now + 2.minutes)

        acc = create(:accumulator, uplink: uplink)

        last_acc = thing.last_accumulators.last

        expect(last_acc.id).to eq(acc.id)
      end
    end

    context "When there are uplinks and no accumulators for the las uplink" do
      it "Should return the last accumulator" do
        create(:uplink, thing: thing, created_at: Time.zone.now)

        uplink = create(:uplink, thing: thing, created_at: Time.zone.now + 1.minutes)

        create(:uplink, thing: thing, created_at: Time.zone.now + 2.minutes)

        acc = create(:accumulator, uplink: uplink)

        last_acc = thing.last_accumulators.last

        expect(last_acc).to be_nil
      end
    end

    context "When there are not uplinks and no accumulators" do
      it "Should return the last accumulator" do
        last_acc = thing.last_accumulators

        expect(last_acc).to be_empty
      end
    end

    context "when there are many accumulators in many uplinks" do
      let(:uplink1) { create(:uplink, thing: thing, created_at: Time.zone.now - 30.seconds) }
      let(:uplink2) { create(:uplink, thing: thing) }
      let(:uplink3) { create(:uplink, thing: thing) }

      let!(:acc1) { create(:accumulator, uplink: uplink1) }
      let!(:acc2) { create(:accumulator, uplink: uplink2) }
      let!(:acc3) { create(:accumulator, uplink: uplink3) }

      it "should return the latest accumulators" do
        last_acc = thing.last_accumulators(2)

        expect(last_acc.length).to eq(2)
        expect(last_acc.pluck(:id)).to match_array([acc3.id, acc2.id])
      end
    end
  end

  describe "#last_uplinks" do
    let(:thing) { create(:thing) }

    context "When there are uplinks" do
      it "Should return the last uplink" do
        create(:uplink, thing: thing, created_at: Time.zone.now)
        create(:uplink, thing: thing, created_at: Time.zone.now + 1.minutes)
        uplink = create(:uplink, thing: thing, created_at: Time.zone.now + 2.minutes)

        last_uplink = thing.last_uplinks.last

        expect(last_uplink.id).to eq(uplink.id)
      end

      it "Should return the last uplinks" do
        create(:uplink, thing: thing, created_at: Time.zone.now)
        create(:uplink, thing: thing, created_at: Time.zone.now + 1.minutes)
        uplink = create(:uplink, thing: thing, created_at: Time.zone.now + 2.minutes)

        last_uplinks = thing.last_uplinks(3)

        expect(last_uplinks.length).to eq(3)
      end
    end

    context "When there are not uplinks" do
      it "Should return the nil" do
        last_uplink = thing.last_uplinks.last

        expect(last_uplink).to be_nil
      end
    end
  end

  context "Validate units" do
    context "The units is empty" do
      it "Should be valid" do
        thing = create(:thing)

        expect(thing).to be_valid
      end
    end

    context "The unit has one value" do
      it "Should be valid" do
        thing = create(:thing, units: { liter: 200 })

        expect(thing).to be_valid
      end
    end

    context "The unit has n empty hash" do
      it "Should be valid" do
        thing = create(:thing, units: {})

        expect(thing).to be_valid
      end
    end

    context "The unit value is zero" do
      it "Should be invalid" do
        thing = build(:thing, units: { my_unit: 0 })

        expect(thing).to_not be_valid
      end
    end
  end
end
