require 'rails_helper'

RSpec.describe Users::Create::Execute do
  describe "#call" do
    let(:country) { create(:country, code_iso: 'CO') }
    let(:input) {
      {
        phone: Faker::PhoneNumber.phone_number,
        email: Faker::Internet.email,
        first_name: Faker::TvShows::Simpsons.character,
        last_name: Faker::TvShows::Simpsons.character,
        country_code: country.code_iso,
        password: 'pass',
        id_type: :cc,
        id_number: '9881304167',
        user_type: :administrator,
        gender: :female,
        admin: true,
        code_number: '9743807606'
      }
    }

    context "When input is valid" do
      it "should return a Success response" do
        expect(User.count).to eq(0)

        response = subject.(input)

        expect(response).to be_success

        user = response.success

        expect(User.count).to eq(1)
        expect(user.first_name).to eq(input[:first_name])
        expect(user.email).to eq(input[:email])
      end
    end

    context "'validate_input' operation" do

      describe "When input has wrong data inputs" do
        it "Should return a failure response" do
          input[:code_number] = 325434
          input[:id_number] = 325434
          input[:first_name] = 325434
          input[:last_name] = 325434
          input[:email] = 325434
          input[:country_code] = 325434
          input[:password] = 325434
          input[:phone] = 325434
          input[:user_type] = "325434"
          input[:admin] = 325434

          response = subject.(input)

          expected_failure = {
            :admin => ["must be TrueClass"],
            :code_number => ["must be String"],
            :email => ["must be String"],
            :country_code => ["must be String"],
            :first_name => ["must be String"],
            :id_number => ["must be String"],
            :last_name => ["must be String"],
            :password => ["must be String"],
            :phone => ["must be String"],
            :user_type => ["must be one of: aqueduct_administrator, administrator, aqueduct_client, aqueduct_operator, citizen_admin, citizen_viewer"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_failure)
        end
      end

      describe "When user data is nil" do
        it "Should return a failure response" do
          input[:first_name] = nil
          input[:email] = nil
          input[:password] = nil
          input[:admin] = nil
          input[:phone] = nil

          expected_response = {
              :first_name => ["must be filled"],
              :email => ["must be filled"],
              :password=> ["must be String"],
              :admin=> ["must be TrueClass"],
              :phone=> ["must be String"]
          }

          response = subject.(input)

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end

    context "'create' operation" do
      describe "When the user email already exist" do
        it "Should return a failure response" do
          existing_email = "bat@mail.com"
          user = create(:user, email: existing_email)
          input[:email] = existing_email

          response = subject.(input)

          expect(response).to be_failure
          expect(User.count).to eq(1)
          expect(User.last.email).to eq(existing_email)
        end
      end
    end
  end
end
