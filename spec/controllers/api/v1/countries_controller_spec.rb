require 'rails_helper'

RSpec.describe Api::V1::CountriesController, type: :request do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => JsonWebToken.encode({ user_id: user.id }), 'HTTP_ACCEPT' => "application/json" } }

  describe 'GET/index countries' do
    context 'There are created countries' do
      let!(:country1) { create(:country) }
      let!(:country2) { create(:country) }

      it 'should return all countries data' do
        
        get "/api/v1/countries", headers: header
        body = JSON.parse(response.body)

        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        expect(response.status).to eq(200)

        expected_response = [
          {
            "name" => country1.name,
            "code_iso" => country1.code_iso
          },
          {
            "name" => country2.name,
            "code_iso" => country2.code_iso
          }
        ]

        expect(body).to match_array(expected_response)
      end
    end
  end
end
