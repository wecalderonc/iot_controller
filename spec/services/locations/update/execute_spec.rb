require 'rails_helper'

RSpec.describe Locations::Update::Execute do
  describe "#call" do
    let(:response) { subject.(input) }

    context "When the user is creating a new location" do
      let(:user)     { create(:user, email: "user@gmail.com") }
      let(:country)  { create(:country, code_iso: 'CO') }
      let(:state)    { create(:state, code_iso: 'CO-DC', country: country) }
      let(:city)     { create(:city, name: 'Bogota', state: state) }
      let(:location) { create(:location, city: city) }
      let(:thing)    { create(:thing, locates: location, owner: user) }
      let(:schedule_billing) { location.schedule_billing }
      let(:schedule_report) { location.schedule_report }

      let(:input) {
        { thing_name: thing.name,
          email: user.email,
          location: {
            name: 'My house',
            address: 'Carrera 7 # 71 - 21',
            latitude: 4.606880,
            longitude: -74.071840
          },
          country_state_city: {
            country: 'CO',
            state: 'CO-DC',
            city: city.name
          },
          schedule_billing: {
            stratum: 5,
            basic_charge_price: 13.841,
            top_limit: 40.0,
            basic_price: 2.000,
            extra_price: 2.500,
            billing_frequency: 2,
            billing_period: 'month',
            cut_day: 10,
            start_day: 10,
            start_month: 10,
            start_year: 2019
          },
          schedule_report: {
            email: 'unacosita@gmail.com',
            frequency_day: 1,
            frequency_interval: 'week',
            start_day: 10,
            start_month: 10,
            start_year: 2019
          }
        }
      }

      context "When all the operations are successful" do
        context"Thing name doesn't change" do
          it "Should return a Success response" do
            expect(response).to be_success

            expect(response.success).to match(location)
            expect(thing.name).to eq(thing.name)
            expect(location.city.name).to eq('Bogota')
            expect(schedule_billing.stratum).to eq(5)
            expect(schedule_report.email).to eq('unacosita@gmail.com')
          end
        end

        context"Thing name have been changed" do
          context "Thing doesn't have relations" do
            it "Should return a Success response" do
              thing2 = create(:thing, name: 'new_name')
              input[:new_thing_name] = 'new_name'

              expect(response).to be_success

              expect(response.success).to match(location)
              expect(location.thing.name).to eq('new_name')
              expect(location.city.name).to eq('Bogota')
              expect(schedule_billing.stratum).to eq(5)
              expect(schedule_report.email).to eq('unacosita@gmail.com')
              expect(thing.locates).to eq(location)
              expect(thing.owner).to include(user)
            end
          end

          context "Thing have already another relations" do
            it "Should return a Success response" do
              user2 = create(:user)
              thing2 = create(:thing, name: 'new_name', owner: user2)
              input[:new_thing_name] = 'new_name'

              expected_response = "Thing already taken by another user"

              expect(response).to be_failure
              expect(response.failure[:message]).to eq(expected_response)
            end
          end
        end

        context"Thing name is empty" do
          it "Should return a Success response" do
            input[:new_thing_name] = ''

            expect(response).to be_success

            expect(response.success).to match(location)
            expect(location.thing).to be_nil
            expect(thing.owner).to be_empty
            expect(thing.locates).to be_nil
            expect(location.city.name).to eq('Bogota')
            expect(schedule_billing.stratum).to eq(5)
            expect(schedule_report.email).to eq('unacosita@gmail.com')
          end
        end
      end

      context "When country is wrong" do
        it "Should return a Failure response" do
          input[:country_state_city][:country] = "invalid_code"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq("Country not found")
        end
      end

      context "When state is wrong" do
        it "Should return a Failure response" do
          input[:country_state_city][:state] = "invalid_code"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq("State not found")
        end
      end

      context "When city is wrong" do
        it "Should return a Failure response" do
          input[:country_state_city][:city] = "invalid_name"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq("City not found")
        end
      end

      context "When the 'get' operation fails" do
        it "Should return a Failure response" do
          input[:thing_name] = "invalid_name"

          expected_response = "The thing invalid_name does not exist"

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end

      context "When the 'get' operation fails" do
        it "Should return a Failure response" do
          input[:email] = "invalid_name"

          expected_response = {:email=>["is in invalid format"]}

          expect(response).to be_failure
          expect(response.failure[:message]).to eq(expected_response)
        end
      end
    end
  end
end
