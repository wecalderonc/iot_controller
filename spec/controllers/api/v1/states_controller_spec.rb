require 'rails_helper'

RSpec.describe Api::V1::StatesController, type: :request do
  describe 'GET/index states' do
    context 'Right country code' do
      let(:colombia)      { create(:country, name: 'Colombia', code_iso: 'CO') }
      let!(:antioquia)    { create(:state, name: 'Antioquia', country: colombia) }
      let!(:cundinamarca) { create(:state, name: 'Cundinamarca', country: colombia) }
      let(:input)         { { country_code: colombia.code_iso } }

      it 'should return all states related with a specific country' do
        
        get "/api/v1/states", params: input
        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = [
          {
            "name" => antioquia.name,
            "code_iso" => antioquia.code_iso,
            "country" => {
              "name" => colombia.name,
              "code_iso" => colombia.code_iso
            }
          },
          {
            "name" => cundinamarca.name,
            "code_iso" => cundinamarca.code_iso,
            "country" => {
              "name" => colombia.name,
              "code_iso" => colombia.code_iso
            }
          }
        ]

        expect(body).to match_array(expected_response)
      end
    end

    context 'Wrong country code' do
      let(:input) { { country_code: 'invalid_code' } }

      it 'should return an error' do
        get "/api/v1/states", params: input
        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(404)

        expected_response =  {
          "errors" => "Country not found",
          "code" => 10104
        }

        expect(body).to match_array(expected_response)
      end
    end
  end
end
