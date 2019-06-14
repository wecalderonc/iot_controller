require 'rails_helper'

RSpec.describe Users::Create do
  describe "#call" do
    let(:input) {
      {
        user: {
          phone: Faker::PhoneNumber.phone_number,
          email: Faker::Internet.email,
          first_name: Faker::TvShows::Simpsons.character,
          password: "pass",
          number_id_type: "CC",
          number_id: Faker::Number.number(10)
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

      describe "When user data is nil" do
        it "Should return a failure response" do
          input[:user] = {
            email: nil,
            first_name: nil,
            password: nil,
          }

          expected_response = {
            :message=> {
              :user=>{
                :first_name => ["must be filled"],
                :email => ["must be filled"],
                :password=> ["must be String"],
              }
            },
            :location => Common::Operations::Validate,
            :extra=>{ code: 400, :params=>{:user=>{:email=>nil, :first_name=>nil, :password=>nil}}}
          }

          response = subject.(input)

          expect(response).to be_failure
          expect(response.failure).to eq(expected_response)
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
