require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Countries API", :type => :request do
  path "/api/v1/countries" do
     get 'Retrieves all Countries' do
      tags 'Countries'
      produces 'application/json'

      response '200', 'things founded' do
        let!(:countries) { create_list(:country, 3) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            name: { type: :string },
            code_iso: { type: :string }
          },
          required: ['name', 'code_iso']
        }

        run_test!
      end
    end
  end
end
