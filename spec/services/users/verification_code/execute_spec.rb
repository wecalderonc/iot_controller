require 'rails_helper'

RSpec.describe Users::VerificationCode::Execute do
  describe "#call" do
    let(:user)    { create(:user) }
    let(:country) { create(:country, code_iso: 'CO') }

    context "When the user can get a verification code" do

      let(:input) { { email: user.email } }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          expect_any_instance_of(UserMailer).to receive(:update_confirmation).once

          allow(SecureRandom).to receive(:hex).with(2).and_return('abcd')

          user.update(verification_code: nil)

          expect(user.verification_code).to be_nil

          response = subject.(input)

          user.reload

          expect(response).to be_success
          expect(response.success.verification_code).to eq('abcd')
        end
      end

      context "When the email does not belong to the user" do
        it "Should return a Failure response" do
          input[:email] = "jconnor@bad"

          response = subject.(input)
          expected_response = "User not found"

          expect(response).to be_failure
          expect(response.failure[:error]).to eq(expected_response)
        end
      end
    end
  end
end
