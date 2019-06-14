require 'rails_helper'

RSpec.describe Users::Create do
  describe "#call" do
    let(:input) {
      {
        user: {
          phone: Faker::PhoneNumber.phone_number,
          email: Faker::Internet.email,
          first_name: Faker::TvShows::Simpsons.character,
          last_name: Faker::TvShows::Simpsons.character,
          password: "pass",
          id_type: :cc,
          id_number: Faker::Number.number(10),
          user_type: :administrator,
          gender: :female,
          admin: true
        }
      }
    }

    context "When input is valid" do
      it "should return a Success response" do
        expect(User.count).to eq(0)

        response = subject.(input)

        expect(response).to be_success

        user = response.success

        expect(User.count).to eq(1)
        expect(user.first_name).to eq(input[:user][:first_name])
        expect(user.email).to eq(input[:user][:email])
      end
    end

    context "'validate_input' operation" do
      describe "When input is incomplete" do
        it "Should return a failure response" do
          input.delete(:user)

          response = subject.(input)

          expected_failure = {:user=>["is missing"]}

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_failure)
        end
      end

      describe "When input has a code number wrong" do
        it "Should return a failure response" do
          input[:user][:code_number] = 325434

          response = subject.(input)

          expected_failure = {:user=>{:code_number=>["must be String"]}}

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_failure)
        end
      end

      describe "When user data is nil" do
        it "Should return a failure response" do
          input[:user][:first_name] = nil
          input[:user][:email] = nil
          input[:user][:password] = nil
          input[:user][:admin] = nil
          input[:user][:phone] = nil
          input[:user][:gender] = nil

          expected_response = {
            :user=>{
              :first_name => ["must be filled"],
              :email => ["must be filled"],
              :password=> ["must be String"],
              :admin=> ["must be TrueClass"],
              :phone=> ["must be String"],
              :gender=> ["must be Symbol"],
            }
          }

          response = subject.(input)

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end

    context "'create' operation" do
      describe "When the user email already exist" do
        it "Should return a success response and update the present user" do
          existing_email = "bat@mail.com"
          user = create(:user, email: existing_email)
          input[:user][:email] = existing_email

          response = subject.(input)

          expect(response).to be_success
          expect(User.count).to eq(1)
          expect(User.last.email).to eq(existing_email)
        end
      end
    end
  end
end
