require 'swagger_helper'

RSpec.describe "Aqueducts API", :type => :request do
  path "/api/v1/aqueducts" do
    get 'Retrieves all Aqueducts' do
      tags 'Aqueducts'
      produces 'application/json'
 
      response '200', 'all aqueducts' do
        let(:Authorization) { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiN2FkYTRlM2MtYTgxNS00ZDkzLWJlMzUtNjFjOTk3Njk0YWRhIiwiZXhwIjoxNTYwNjQ3Mjk0fQ.F3wyqG1JGGvzBdjJFL5X_SubB9TbJBn4IyEpZZ6nDog' }
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
            },
            required: [ 'id', 'email', 'name' ]
          }
        run_test!
      end

      response '404', 'user not found' do
        let(:email) { "invalid_email" }
        run_test!
      end
    end
  end
end
