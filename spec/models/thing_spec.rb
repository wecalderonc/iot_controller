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
  it { expect(Thing.serialized_properties).to include({:coordinates=>{:type=>Array}}) }

  it { is_expected.to have_one(:uplinks).with_direction(:out) }

  it { is_expected.to have_many(:owner).with_direction(:in) }
  it { is_expected.to have_many(:operator).with_direction(:in) }
  it { is_expected.to have_many(:viewer).with_direction(:in) }


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

    context "When there are uplinks and no accumulators" do
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


    context "when there are accumulators" do
      let(:accumulator) { create(:accumulator, created_at: Time.zone.now) }
      let!(:uplink) { create(:uplink, thing: accumulator.uplink.thing) }
      let!(:uplink2) { create(:uplink, thing: accumulator.uplink.thing) }
      let!(:accumulator2) { create(:accumulator, uplink: uplink, created_at: Time.zone.now) }
      let!(:accumulator3) { create(:accumulator, uplink: uplink2, created_at: Time.zone.now) }

      it "should return the latest accumulators" do
        thing = accumulator.uplink.thing
        last_accumulators = thing.last_accumulators(3)

        expect(last_accumulators.length).to eq(3)
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

  describe "#last_accumulators" do
    let(:thing) { create(:thing) }

    context "When there are accumulators" do
      it "should return the last accumulator" do
        uplink = create(:uplink, thing: thing)
        accumulator = create(:accumulator, uplink: uplink )

        last_accumulator = thing.last_accumulators.last
        expect(last_accumulator.id).to eq(accumulator.id)
      end

      it "should return the last accumulators" do
        uplink = create(:uplink, thing: thing)
        uplink2 = create(:uplink, thing: thing)
        uplink3 = create(:uplink, thing: thing)
        uplink4 = create(:uplink, thing: thing)
        create(:accumulator, uplink: uplink )
        create(:accumulator, uplink: uplink2 )
        create(:accumulator, uplink: uplink3 )
        create(:accumulator, uplink: uplink4 )

        last_accumulators = thing.last_accumulators(4)

        expect(last_accumulators.length).to eq(4)
      end
    end

    context "When there are not accumulators" do
      it "Should return the nil" do
        last_accumulator = thing.last_accumulators.last

        expect(last_accumulator).to be_nil
      end
    end
  end

end
