require 'rails_helper'

RSpec.describe User, :type => :model do

  it { is_expected.to have_many(:owns).with_direction(:out) }
  it { is_expected.to have_many(:operates).with_direction(:out) }
  it { is_expected.to have_many(:sees).with_direction(:out) }
  it { is_expected.to have_many(:locates).with_direction(:out) }

  it { is_expected.to have_one(:country).with_direction(:out) }

  describe "Validations" do
    it "email and password are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :email=>["can't be blank"],
        :password=>["can't be blank"],
        :first_name=>["can't be blank"],
        :last_name=>["can't be blank"]
      }

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end

  describe "The id number already exists" do
    it "Should return an error" do
      create(:user, id_number: "123456")

      user = build(:user, id_number: "123456")

      expect(user).to_not be_valid

      expected_errors = {
        :id_number=>["has already been taken"],
      }

      expect(user.errors.messages).to eq(expected_errors)
    end
  end

  describe "#valid_password?" do
    context "the input password is valid" do
      it "should return true" do
        user = create(:user, email: "danielapatino@gmail.com", password: "dani123")
        response = user.valid_password?("dani123")

        expect(response).to be_truthy
      end
    end
    context "the input password is invalid" do
      it "should return false" do
        user = create(:user, email: "danielapatino@gmail.com", password: "dani123")
        response = user.valid_password?("dani126")

        expect(response).to be_falsey
      end
    end
  end

  describe "#assign_verification_code" do
    context "User created has a verification_code" do
      it "should return true" do
        user = create(:user, email: "danielapatino@gmail.com", password: "dani123")

        expect(user.verification_code).to be_truthy
      end
    end

    context "User created is already verified and verification_code is nil" do
      it "should return false" do
        user = create(:user, email: "danielapatino@gmail.com", password: "dani123")
        user.email_activate

        expect(user.verification_code).to be_falsey
      end
    end
  end

  describe "#email-activate" do
    context "User created is been verified" do
      it "should return true to verificated and nil verification_code" do
        user = create(:user, email: "danielapatino@gmail.com", password: "dani123")
        expect(user.verification_code).to be_truthy
        expect(user.verificated).to be false

        user.email_activate

        expect(user.verification_code).to be_falsey
        expect(user.verificated).to be true
      end
    end
  end
end
