require 'rails_helper'

RSpec.describe Users::Update::Execute do
  describe "#call" do
    context "When the user is updating user params" do
      let(:user)    { create(:user, email: "user@gmail.com") }
      let(:country) { create(:country, code_iso: 'CO') }

      let(:input) {
        {
          email: "user@gmail",
          format: "com",
          first_name: "Daniela",
          last_name: "Patiño",
          new_email: "dpatino@proci.com",
          country_code: country.code_iso,
          current_password: user.password,
          password: "nuevopassword",
          password_confirmation: "nuevopassword"
        }
      }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          expect_any_instance_of(UserMailer).to receive(:update_confirmation).once

          response = subject.(input)

          expect(response).to be_success
          expect(response.success.first_name).to match("Daniela")
          expect(response.success.last_name).to match("Patiño")
          expect(response.success.email).to match("dpatino@proci.com")
          expect(response.success.password).to match("nuevopassword")
          expect(response.success.country.code_iso).to match("CO")
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:first_name] = 12345

          response = subject.(input)
          expected_response = {
            :first_name => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:last_name] = 12345

          response = subject.(input)
          expected_response = {
            :last_name => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:new_email] = 123456

          response = subject.(input)
          expected_response = {
            :new_email => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:country_code] = 12345

          response = subject.(input)
          expected_response = {
            :country_code => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:current_password] = 12345

          response = subject.(input)
          expected_response = {
            :current_password => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:password] = 12345

          response = subject.(input)
          expected_response = {
            :password => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:password_confirmation] = 12345

          response = subject.(input)

          expected_response = {
            :password_confirmation => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:password_confirmation] = "12345"
          input.delete(:password)

          response = subject.(input)

          expected_response = {
            :new_password => ["Missing new password"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When country code is wrong" do
        it "Should return a Failure response" do
          input[:country_code] = "invalid_code"

          response = subject.(input)

          expect(response).to be_failure
          expect(response.failure[:message]).to eq("Country not found")
        end
      end

      context "When the 'get' operation fails" do
        it "Should return a Failure response" do
          input[:email] = "invalid_id"

          response = subject.(input)

          expected_response = "User not found"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
