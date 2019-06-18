require 'swagger_helper'

RSpec.describe "Things API", :type => :request do
  path "/api/v1/things/{id}" do
    get 'Retrieves a thing' do
      tags 'Things'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'thing found' do
        let(:user) { create(:user) }
        let(:id) { create(:thing, :activated).id }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: [ 'thing' ],
          properties: {
            thing: {
              type: :object,
              required: [ 'id', 'name', 'status', 'pac', 'company_id' ],
              items:
                {
                  properties: {
                    id: { type: :string },
                    name: { type: :string },
                    status: { type: :string },
                    pac: { type: :string },
                    company_id: { type: :string },
                  }
              }
            }
          }
        run_test!
      end

      response '404', 'thing not found' do
        let(:user) { create(:user) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        let(:id) { "invalid_id" }

        run_test!
      end
    end
  end
end
