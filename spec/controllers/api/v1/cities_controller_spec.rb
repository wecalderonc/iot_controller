require 'rails_helper'

RSpec.describe Api::V1::CitiesController, type: :request do
  describe 'GET/index cities' do
    context 'Right state code' do
      let(:colombia)     { create(:country, name: 'Colombia', code_iso: 'CO') }
      let(:cundinamarca) { create(:state, name: 'Cundinamarca', country: colombia) }
      let!(:cajica)      { create(:city, name: 'Cajica', state: cundinamarca) }
      let!(:mosquera)    { create(:city, name: 'Mosquera', state: cundinamarca) }
      let(:input)        { { state_code: cundinamarca.code_iso } }

      it 'should return all cities related with a specific state' do
        
        get "/api/v1/cities", params: input
        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = [
          {
            "name" => cajica.name,
            "state" => {
              "name" => cundinamarca.name,
              "code_iso" => cundinamarca.code_iso
            }
          },
          {
            "name" => mosquera.name,
            "state" => {
              "name" => cundinamarca.name,
              "code_iso" => cundinamarca.code_iso
            }
          }
        ]

        expect(body).to match_array(expected_response)
      end
    end

    context 'Wrong state code' do
      let(:input) { { state_code: 'invalid_code' } }

      it 'should return an error' do
        get "/api/v1/cities", params: input
        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        expected_response =  {
          "errors" => "State not found",
          "code" => 10104
        }

        expect(body).to match_array(expected_response)
      end
    end
  end
end
