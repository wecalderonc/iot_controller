require 'rails_helper'

RSpec.describe Users::Update::Execute do
  describe "#call" do
    context "When the user is updating user params" do
      let(:user) { create(:user) }
      let(:input) {
        { id: user.id,
          first_name: "Daniela",
          last_name: "Patiño",
          email: "dpatino@proci.com",
          country: "colombia",
          current_password: user.password,
          password: "nuevopassword",
          password_confirmation: "nuevopassword"
        }  
      }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          response = subject.(input)

          expect(response).to be_success
          expect(response.success.first_name).to match("Daniela")
          expect(response.success.last_name).to match("Patiño")
          expect(response.success.email).to match("dpatino@proci.com")
          expect(response.success.country).to match("colombia")
          expect(response.success.password).to match("nuevopassword")
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
          input[:email] = 123456

          response = subject.(input)
          expected_response = {
            :email => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails" do
        it "Should return a Failure response" do
          input[:country] = 12345

          response = subject.(input)
          expected_response = {
            :country => ["must be String"]
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
          iput.delete(:password)

          response = subject.(input)
          expected_response = {
            :new_password => ["Missing new password"]
          }

          expect(response).to be_failure
          expect(response.failure[:message][:params]).to eq(expected_response)
        end
      end

      context "When the 'get' operation fails" do
        it "Should return a Failure response" do
          input.delete(:first_name)

          response = subject.(input)
          expected_response = "The thing  does not exist"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
