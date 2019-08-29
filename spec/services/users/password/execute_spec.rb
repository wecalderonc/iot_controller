require 'rails_helper'

RSpec.describe Users::Password::Execute do
  describe "#call" do
    let(:user) { create(:user, email: "test@gmail.com") }

    context "When a user is trying to recover password" do
      let(:input) {
        {
          email: "test@gmail.com",
          current_password: user.password,
          password: "new_password",
          password_confirmation: "new_password"
        }
      }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success.first_name).to match(user.first_name)
          expect(response.success.last_name).to match(user.last_name)
          expect(response.success.email).to match(user.email)
          expect(response.success.password).to match("new_password")
        end
      end

      context "When the 'validation' operation fails with wrong type of inputs" do
        it "Should return a Failure response" do
          input[:current_password] = 12345
          input[:password_confirmation] = 12345
          input[:password] = true

          response = subject.(input)

          expected_response = {
            :current_password => ["must be String"],
            :password => ["must be String"],
            :password_confirmation => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails with different new_password and new_password_confirmation" do

        it "Should return a Failure response" do
          input[:password_confirmation] = "different_new_password"

          response = subject.(input)

          expected_response = {
            :same_password => ["The new password doesn't match with the confirmation"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'comparison' operation fails with email and password are not related" do

        it "Should return a Failure response" do
          input[:current_password] = "different_new_password"

          response = subject.(input)

          expected_response = "Current Password is incorrect"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
