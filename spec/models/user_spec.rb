require 'rails_helper'

RSpec.describe User, :type => :model do

  it { is_expected.to have_many(:owns).with_direction(:out) }
  it { is_expected.to have_many(:operates).with_direction(:out) }
  it { is_expected.to have_many(:sees).with_direction(:out) }

  describe "Validations" do
    it "email and password are required" do
      expect(subject).to_not be_valid

      expected_errors = {
        :email=>["can't be blank"],
        :password=>["can't be blank"],
        :phone=>["can't be blank"],
        :first_name=>["can't be blank"],
        :last_name=>["can't be blank"],
        :gender=>["can't be blank"],
        :id_type=>["can't be blank"],
        :id_number=>["can't be blank"],
        :user_type=>["can't be blank"],
      }

      expect(subject.errors.messages).to eq(expected_errors)
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
end
