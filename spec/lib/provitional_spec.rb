require 'rails_helper'

RSpec.describe Provitional do
  describe "#sum" do
    context "two numbers" do
      it "should return the sum of those numbers" do
        expect(Provitional.sum(2,3)).to eq(5)
      end
    end
  end
end
