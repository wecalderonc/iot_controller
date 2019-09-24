require 'swagger_helper'
require 'rails_helper'

RSpec.describe "States API", :type => :request do
  path "/api/v1/states" do
    get 'Retrieves all states related with a specific country' do
      tags 'States'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :country_code, :in => :query, :type => :string

      response '200', 'states founded' do
        let(:colombia) { create(:country, code_iso: 'CO') }
        let!(:state) { create(:state, country: colombia) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            name: { type: :string },
            code_iso: { type: :string },
            country: { 
              type: :object,
              properties: {
                name: { type: :string },
                code_iso: { type: :string },
              }
            }
          },
          required: ['name', 'code_iso', 'country']
        }

        let(:country_code) { 'CO' }

        run_test!
      end

      response '404', 'country not found' do
        let(:country_code) { 'invalid_code' }

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
