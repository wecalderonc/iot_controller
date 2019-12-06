require 'rails_helper'

RSpec.describe Users::Locations::Index::Execute do
  describe "#call" do
    let(:location) { create(:location) }
    let(:location2) { create(:location) }
    let(:location3) { create(:location) }
    let(:user) { create(:user) }

    context "When a user is trying to get all his locations" do
      let(:input) { { email: user.email } }

      context "When all the operations are successfull" do
        it "Should return a Success response" do
          UserLocation.create(from_node: user, to_node: location)
          UserLocation.create(from_node: user, to_node: location2)
          UserLocation.create(from_node: user, to_node: location3)

          response = subject.(input)

          first_location = {
            "id"=>location.id,
            "name"=>location.name,
            "address"=>location.address,
            "created_at"=>JSON.parse(location.created_at.to_json),
            "updated_at"=>JSON.parse(location.updated_at.to_json),
            "latitude"=>location.latitude,
            "longitude"=>location.longitude,
          }
          second_location = {
            "id"=>location2.id,
            "name"=>location2.name,
            "address"=>location2.address,
            "created_at"=>JSON.parse(location2.created_at.to_json),
            "updated_at"=>JSON.parse(location2.updated_at.to_json),
            "latitude"=>location2.latitude,
            "longitude"=>location2.longitude,
          }
          third_location = {
            "id"=>location3.id,
            "name"=>location3.name,
            "address"=>location3.address,
            "created_at"=>JSON.parse(location3.created_at.to_json),
            "updated_at"=>JSON.parse(location3.updated_at.to_json),
            "latitude"=>location3.latitude,
            "longitude"=>location3.longitude,
          }

          expect(response).to be_success
          expect(response.success.include?(first_location))
          expect(response.success.include?(second_location))
          expect(response.success.include?(third_location))
          expect(response.success.count).to match(3)
        end
      end

      context "When the 'validation' operation fails with wrong type of input" do
        it "Should return a Failure response" do
          input[:email] = 12345

          response = subject.(input)

          expected_response = {
            :email => ["must be String"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'validation' operation fails without email in body" do

        it "Should return a Failure response" do
          input.delete(:email)

          response = subject.(input)

          expected_response = {
            :email => ["is missing"]
          }

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'get user' operation fails" do

        it "Should return a Failure response" do
          input[:email] = "wrong@email.com"

          response = subject.(input)

          expected_response = "User not found"

          expect(response).to be_failure
          expect(response.failure[:error]).to eq(expected_response)
        end
      end

      context "When the 'get locations' operation fails" do

        it "Should return a Failure response" do
          response = subject.(input)

          expected_response = "The user #{user.email} does not have locations"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
