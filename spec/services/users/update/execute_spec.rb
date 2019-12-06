require 'rails_helper'

RSpec.describe Users::Update::Execute do
  describe "#call" do
    context "When the user is updating user params" do
      let(:user)    { create(:user, email: "user@gmail.com") }
      let!(:user2)  { create(:user, email: "jvaron@proci.com") }
      let!(:user3)  { create(:user, email: "dpatino@proci.com") }
      let(:country) { create(:country, code_iso: 'CO') }

      let(:input) {
        {
          email: "user@gmail.com",
          first_name: "Daniela",
          last_name: "Patiño",
          new_email: "new_email@proci.com",
          country_code: country.code_iso,
          current_password: user.password,
          password: "Proci123*",
          password_confirmation: "Proci123*"
        }
      }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success.first_name).to match("Daniela")
          expect(response.success.last_name).to match("Patiño")
          expect(response.success.email).to match("new_email@proci.com")
          expect(response.success.password).to match("Proci123*")
          expect(response.success.country.code_iso).to match("CO")
        end
      end

      context "When the email and new_email are the same" do
        it "Should return a Failure response" do
         input[:first_name] = "Diana"
         input[:new_email] = "user@gmail.com"

          response = subject.(input)
          expected_response = user
          expect(response).to be_success
          expect(response.success).to eq(expected_response)
        end
      end

      context "When the new_email belongs to another registered user" do
        it "Should return a Failure response" do
         input[:new_email] = "jvaron@proci.com"

          response = subject.(input)
          expected_response = {
            :uniq_email => ["Email already exist"]
          }
          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
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

      context "When the 'validation' operation fails with invalid format passwords" do
        it "Should return a Failure response" do
          input[:password] = "12345"

          response = subject.(input)

          expected_response = {
            :password => ["is in invalid format"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails with invalid format passwords" do
        it "Should return a Failure response" do
          input[:password] = "Proci123*"
          input.delete(:password_confirmation)

          response = subject.(input)

          expected_response = {
            :wrong_password_confirmation => ["Missing password confirmation"]
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
          input[:email] = "invalid_id@proci.com"

          response = subject.(input)

          expected_response = "User not found"

          expect(response).to be_failure
          expect(response.failure[:error]).to eq(expected_response)
        end
      end
    end
  end
end
