require 'rails_helper'

RSpec.describe Users::Create do
  describe "#call" do
    let(:input) {
      {
        user: {
          uniq_param: :email,
          phone: Faker::PhoneNumber.phone_number,
          email: Faker::Internet.email,
          name: Faker::Simpsons.character,
          number_id_type: "CC",
          number_id: Faker::Number.number(10)
        }
      }
    }

    context "When input is valid" do
      it "should return a Success response" do
        response = subject.(input)

        expect(response).to be_success

        user = response.success

        expect(User.count).to eq(1)
        expect(user.name).to eq(input[:user][:name])
        expect(user.number_id).to eq(input[:user][:number_id])
        expect(user.store_id.to_i).to eq(input[:user][:store_id])
        expect(user.store_name).to eq(input[:user][:store_name])
        expect(user.phone).to eq(input[:user][:phone])
        expect(user.email).to eq(input[:user][:email])
        expect(user.address).to eq(input[:user][:street_1])
        expect(user.city.name).to eq("Bogotá D.C.")
      end
    end

    context "'validate_input' operation" do
      describe "When input is incomplete" do
        it "Should return a failure response" do
          input.delete(:user)
          response = subject.(input)

          expected_failure = {:user=>["is missing"]}

          expect(response).to be_failure
          expect(response.failure[:error]).to eq(expected_failure)
        end
      end

      describe "When user data is nil" do
        it "Should return a failure response" do
          input[:user] = {
            city: nil,
            phone: nil,
            email: nil,
            name: nil,
            number_id: nil,
          }

          expected_response = {
            :error => {
              :seller=>{
                :number_id => ["is missing"],
                :name => ["is mising"],
                :phone => ["is mising"],
                :email => ["is mising"],
                :address => ["is mising"],
                :city => ["is mising"]
              }
            },
            :location => Common::Operations::Validate,
            :extra=>{ code: 400 }
          }
          response = subject.(input)
          expect(response).to be_failure
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
