require 'rails_helper'

RSpec.describe Users::VerificationCode::Execute do
  describe "#call" do
    let(:user)    { create(:user) }
    let(:country) { create(:country, code_iso: 'CO') }

    context "When the user obtain a new verification code" do

      let(:input) { { email: user.email } }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          expect_any_instance_of(UserMailer).to receive(:update_confirmation).once
          user.verification_code = nil

          response = subject.(input)

          user.reload

          expect(response).to be_success
          expect(response.success).to eq(user)
          expect(response.success.verification_code).to eq(user.verification_code)
        end
      end

      context "When the email does not match the one the user created" do
        it "Should return a Success response" do
          input[:email] = "jconnor@bad"

          response = subject.(input)
          expected_response = "User not found"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
