require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Cities API", :type => :request do
  path "/api/v1/cities" do
    get 'Retrieves all cities related with a specific state' do
      tags 'Cities'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :state_code, :in => :query, :type => :string

      response '200', 'cities founded' do
        let(:colombia) { create(:country, code_iso: 'CO') }
        let(:cundinamarca) { create(:state, name: 'Cundinamarca', code_iso: 'CUN', country: colombia) }
        let!(:cajica)      { create(:city, name: 'Cajica', state: cundinamarca) }
        let!(:mosquera)    { create(:city, name: 'Mosquera', state: cundinamarca) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            name: { type: :string },
            state: { 
              type: :object,
              properties: {
                name: { type: :string },
                code_iso: { type: :string },
              }
            }
          },
          required: ['name', 'state']
        }

        let(:state_code) { 'CUN' }

        run_test!
      end

      response '404', 'state not found' do
        let(:state_code) { 'invalid_code' }

        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          required: [ 'errors' ]

        run_test!
      end
    end
  end
end
