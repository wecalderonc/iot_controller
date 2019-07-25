require 'rails_helper'

RSpec.describe Types::QueryType do
  describe 'things' do
    let(:result) { IotControllerSchema.execute(query_string) }
    let(:things) { result.to_h['data']['things'] }

    context 'querying by a thing model field' do
      context 'there are things with that property' do
        let!(:thing1) { create(:thing, name: '42040', status: 'activated') }
        let!(:thing2) { create(:thing, name: '42916', status: 'activated', latitude: 0.1, longitude: 1.2) }
        let!(:thing3) { create(:thing, name: '42916', status: 'desactivated', latitude: 0.1, longitude: 1.2) }

        # Querying examples

        context 'status field' do
          let(:query_string) {
            "{
              things(thingInput: { status: \"activated\" }) {
                id
                status
              }
            }"
          }

          it 'should return all things related with that property' do
            expect(things.count).to eq(2)
            expect(things[0]).to include('id', 'status')
          end
        end

        context 'coordinates field' do
          let(:query_string) {
            "{
              things(thingInput: { latitude: 0.1, longitude: 1.2 }) {
                id
                companyId
                longitude
                latitude
              }
            }"
          }

          it 'should return all things related with that property' do
            expect(things.count).to eq(2)
            expect(things[0]).to include('id', 'companyId', 'longitude', 'latitude')
          end
        end
      end
      context 'there are not things with that property' do
        let(:query_string) {
          "{
            things(thingInput: { latitude: 0.0 }) {
              id
              companyId
              longitude
            }
          }"
        }

        it 'should return 0 things related with that property' do
          expect(things.count).to eq(0)
        end
      end
    end
  end

  describe 'thing' do
    let(:result) { IotControllerSchema.execute(query_string) }
    let(:thing) { result.to_h['data']['thing'] }

    context 'querying by a thing model field' do
      context 'there is a thing with that property' do
        let!(:thing1) { create(:thing, name: '42040', status: 'activated') }
        let!(:thing2) { create(:thing, name: '42916', status: 'activated', latitude: 0.1, longitude: 1.2) }

        # Querying examples

        context 'status field' do
          let(:query_string) {
            "{
              thing(thingInput: { name: \"42040\" }) {
                id
                status
              }
            }"
          }

          it 'should return a thing related with that property' do
            expect(thing).to include('id', 'status')
          end

        end

        context 'ask for a field that does not exist' do
          let(:query_string) {
            "{
              thing(thingInput: { name: \"42040\" }) {
                id
                status
                esteCampoNoExiste
              }
            }"
          }

          it 'should return a thing related with that property' do
            expect(result['errors'][0]).to include({"message"=>"Field 'esteCampoNoExiste' doesn't exist on type 'Thing'"})
          end
        end

        context 'latitude and longitude fields' do
          let(:query_string) {
            "{
              thing(thingInput: { latitude: 0.1, longitude: 1.2 }) {
                id
                companyId
                latitude
                longitude
              }
            }"
          }

          it 'should return a thing related with that property' do
            expect(thing).to include('id', 'companyId', 'latitude', 'longitude')
          end
        end
      end
      context 'there is not thing with that property' do
        let(:query_string) {
          "{
            thing(thingInput: { latitude: 0.0 }) {
              id
              companyId
              latitude
            }
          }"
        }

        it 'should not return things' do
          expect(thing).to be_nil
        end
      end
    end
  end

  describe 'user' do
    let(:result) { IotControllerSchema.execute(query_string) }
    let(:user) { result.to_h['data']['user'] }

    context 'querying by a user model field' do
      context 'there is a user with that property' do
        let!(:user1) { create(:user, first_name: 'dani', last_name: 'patino') }
        let!(:user3) { create(:user, first_name: 'lalo', last_name: 'tellez') }
        let!(:thing) { create_list(:thing, 2, owner: user1) }

        context 'firstName field' do
          let(:query_string) {
            "{
              user(userInput: { first_name: \"dani\" }) {
                id
                firstName
                gender
                things {
                  name
                }
              }
            }"
          }

          it 'should return a user related with that property' do
            expect(user).to include('id', 'firstName', 'gender', 'things')
            expect(user['things'][0]).to include('name')
            expect(user['things'].count).to eq(2)
          end
        end

        context 'lastName field' do
          let(:query_string) {
            "{
              user(userInput: { last_name: \"tellez\" }) {
                id
                lastName
                gender
              }
            }"
          }

          it 'should return a user related with that property' do
            expect(user).to include('id', 'lastName', 'gender')
          end
        end
      end
      context 'there is not user with that property' do
          let(:query_string) {
            "{
              user(userInput: { last_name: \"bujabuja\" }) {
                id
                firstName
                gender
              }
            }"
          }


        it 'should not return things' do
          expect(user).to be_nil
        end
      end
    end
  end
end
