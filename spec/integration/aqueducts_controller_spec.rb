require 'swagger_helper'

RSpec.describe "Aqueducts API", :type => :request do
  path "/api/v1/aqueducts" do
    get 'Retrieves all Aqueducts' do
      tags 'Aqueducts'
      produces 'application/json'
 
      response '200', 'all aqueducts' do
        let(:user) { create(:user) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }
        parameter({
          :in => :header,
          :type => :string,
          :name => :Authorization,
          :required => true,
          :description => 'Client token'
        })

        let(:aqueduct) { create(:aqueduct) }
        schema type: :array,
        items: {
          type: :object,
            properties: {
              id: { type: :string },
              email: { type: :string },
              name: { type: :string },
              phone: { type: :string },
            },
            required: [ 'id', 'email', 'name' ]
          }
        run_test!
      end
    end
  end
end
