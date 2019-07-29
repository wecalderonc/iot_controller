require 'rails_helper'

RSpec.describe Price, type: :model do
  it { is_expected.to define_property :unit, :String }
  it { is_expected.to define_property :value, :Float }
  it { is_expected.to define_property :date, :Date }
  it { is_expected.to define_property :currency, :String }

  describe "Validations" do
    it "all attributes are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :currency=>["can't be blank", "is not included in the list"],
        :date=>["can't be blank"],
        :value=>["can't be blank", "is not a number"],
        :unit=>["can't be blank"]
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end

    context "The value is zero" do
      it "The Price should not be valid" do
        price = build(:price, value: 0)

        expect(price).to_not be_valid
        expect(price.errors.messages).to eq({:value=>["must be greater than 0"]})
      end
    end

    context "The currency does not exist" do
      it "The Price should not be valid" do
        price = build(:price, currency: 'HOLI')

        expect(price).to_not be_valid
        expect(price.errors.messages).to eq({:currency=>["is not included in the list"]})
      end
    end
  end

  describe "#by_unit" do
    context "The unit exists in the db" do
      it "Should return a price instance" do
        create(:price, unit: :metter)
        price = create(:price, unit: :liter)

        response = Price.by_unit :liter

        expect(response.id).to eq(price.id)
      end
    end

    context "The unit exists in the db" do
      it "Should return nil" do
        response = Price.by_unit :liter

        expect(response).to be_nil
      end
    end
  end
end
