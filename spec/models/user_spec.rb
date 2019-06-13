require 'rails_helper'

RSpec.describe User, :type => :model do

  describe "Validations" do
    it "email and password are required" do
      expect(subject).to_not be_valid

      expected_errors = {:email=>["can't be blank"], :password=>["can't be blank"]}

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
