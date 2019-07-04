require 'swagger_helper'

RSpec.describe "Accumulators API", :type => :request do

  path "/api/v1/accumulators_report/{id}" do
    get 'Retrieves a last accumulators of a thing' do
      tags 'Things'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string
      parameter name: :query, :in => :query, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'last accumulators for thing found' do
        let(:user) { create(:user) }
        let(:accumulator) { create(:accumulator) }
        let(:id) { accumulator.uplink.thing.id }
        let(:query) { 'last_accumulators' }

        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: accumulator_properties,
          required: accumulator_fields
        }
        run_test!
      end
    end
  end
end
