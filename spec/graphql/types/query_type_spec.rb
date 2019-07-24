require 'rails_helper'

RSpec.describe Types::QueryType do
  describe 'things' do
    let(:result) { IotControllerSchema.execute(query_string) }
    let(:things) { result.to_h['data']['things'] }

    context 'searching by a thing model field' do
      context 'there are things with that property' do
        let!(:thing1) { create(:thing, name: '42040', status: 'activated') }
        let!(:thing2) { create(:thing, name: '42916', status: 'activated', coordinates: [0.1, 1.2]) }
        let!(:thing3) { create(:thing, name: '42916', status: 'desactivated', coordinates: [0.1, 1.2]) }

        context 'status field' do
          let(:query_string) {
            "{
              things(status: \"activated\") {
                id
                status
              }
            }"
          }

          it 'should return all things related with that property' do
            expect(things.count).to eq(2)
            expect(things[0]).to include("id", "status")
          end
        end

        context 'status companyId' do
          let(:query_string) {
            "{
              things(coordinates: \[0.1, 1.2\]) {
                id
                companyId
                coordinates
              }
            }"
          }

          it 'should return all things related with that property' do
            expect(things.count).to eq(2)
            expect(things[0]).to include("id", "companyId", "coordinates")
          end
        end
      end
      context 'there are not things with that property' do
        let(:query_string) {
          "{
            things(coordinates: \[\]) {
              id
              companyId
              coordinates
            }
          }"
        }

        it 'should return 0 things related with that property' do
          expect(things.count).to eq(0)
        end
      end
    end
  end
end
