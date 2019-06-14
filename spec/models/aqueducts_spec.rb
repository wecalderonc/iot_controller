require 'rails_helper'

RSpec.describe Aqueducts, :type => :model do

  describe "Validations" do
    it "email and password are required" do
      expect(subject).to_not be_valid

      expected_errors = {:name=>["can't be blank"], :email=>["can't be blank"], :phone=>["can't be blank"]}

      expect(subject.errors.messages).to eq(expected_errors)
    end
  end
end
