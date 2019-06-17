require 'swagger_helper'

RSpec.describe "Things API", :type => :request do
  path "/api/v1/things" do
    get 'Retrieves all things' do
      tags 'Things'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'all things' do
        let(:user) { create(:user) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing) { create(:thing, :activated) }

        schema type: :array,
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
                    company_id: { type: :string }
                  }
                }
            }
          }
        run_test!
      end
    end
  end
end
