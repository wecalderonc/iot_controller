require 'rails_helper'

RSpec.describe Users::Create::Execute do
  describe "#call" do
    context "When someone is signing up" do
      let(:country) { create(:country, code_iso: 'CO') }
      let(:input) {
        {
          first_name: "user_name_test",
          last_name: "user_last_test",
          email: "test@gmail.com",
          country_code: country.code_iso,
          password: "validpass",
          phone: "3013632461",
          gender: "male",
          id_number: "123456",
          id_type: "cc",
          code_number: "1032428363",
          admin: true,
          user_type: "administrator"
        }
      }

      context "When all the operations are successful" do
        it "Should return a Success response" do
          expect_any_instance_of(UserMailer).to receive(:confirmation_email).once

          response = subject.(input)

          expect(response).to be_success
          expect(response.success.first_name).to match("user_name_test")
          expect(response.success.last_name).to match("user_last_test")
          expect(response.success.email).to match("test@gmail.com")
          expect(response.success.phone).to match("3013632461")
          expect(response.success.gender).to match("male")
          expect(response.success.id_number).to match("123456")
          expect(response.success.id_type).to match("cc")
          expect(response.success.code_number).to match("1032428363")
        end
      end

      context "When the 'validation' operation fails with wrong type of inputs" do
        it "Should return a Failure response" do
          input[:first_name] = 12345
          input[:last_name] = 12345
          input[:email] = 12345
          input[:country_code] = 12345
          input[:phone] = 12345
          input[:gender] = 12345.to_s
          input[:id_number] = 12345
          input[:id_type] = 12345.to_s

          response = subject.(input)

          expected_response = {
            :email => ["must be String"],
            :first_name => ["must be String"],
            :country_code => ["must be String"],
            :invalid_gender => ["must be one of: male, female"],
            :id_number => ["must be String"],
            :invalid_id_type => ["must be one of: cc, ce, natural_nit, bussines_nit, foreign_nit, passport, civil_register"],
            :last_name => ["must be String"],
            :phone => ["must be String"],
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails with duplicate user email" do
        let(:user) { create(:user) }

        it "Should return a Failure response" do
          input[:first_name] = "name"
          input[:last_name] = "last_name"
          input[:email] = user.email
          input[:phone] = "3013632461"
          input[:gender] = "male"
          input[:id_number] = user.id_number
          input[:id_type] = "cc"

          response = subject.(input)

          expected_response = {
            :uniq_email => ["Email already exist"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
