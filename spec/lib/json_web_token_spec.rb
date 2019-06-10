require 'rails_helper'

RSpec.describe JsonWebToken do
  subject { described_class }
  describe "#encode" do
    it "should encode an id" do
      valid_token = "eyJhbGciOiJIUzI1NiJ9.eyJhcGlfdXNlcl9pZCI6MywiZXhwIjoxNTMwOTUyMDMzfQ.MW1tzWpDQWrZWgepHMoaT4vDVL0nT7H3yb_tfNQjYk0"

      expect(JsonWebToken).to receive(:encode).and_return(valid_token)

      response = subject.encode( { user_id: 123 } )

      expect(response).to eq(valid_token)
    end
  end

  describe "#decode" do
    context "token is ok" do
      it "should decode an id" do
        token = subject.encode( { user_id: 123 } )

        response = subject.decode(token).value!

        expect(response[:user_id]).to eq(123)
      end
    end
    context "token is bad" do
      it "should decode an id" do
        token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMjMsImV4cCI6MTU2MDIwMjc4NH0._oI8ERlkWpKBvu75U7i4E5rnyUQ_tHKrc3v68ZAiWKo"

        response = subject.decode(token)

        expect(response.exception.message).to eq("Signature has expired")
      end
    end
  end
end
