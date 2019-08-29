require 'swagger_helper'

RSpec.describe "Accumulators API", :type => :request do

  path "/api/v1/accumulators_report/" do
    get 'Retrieves last accumulators of a thing' do
      tags 'Things'
      produces 'application/json'
      parameter name: :thing_name, :in => :query, :type => :string
      parameter name: :query, :in => :query, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'last accumulators for thing found' do
        let(:user)            { create(:user) }
        let(:accumulator)     { create(:accumulator) }
        let(:thing_name)      { accumulator.uplink.thing.name }
        let(:query)           { 'last_accumulators' }

        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: accumulator_properties,
          required: accumulator_fields
        }
        run_test!
      end

      response '404', 'thing not found' do
        let(:user)            { create(:user) }
        let(:accumulator)     { create(:accumulator) }
        let(:thing_name)      { "wrong_name" }
        let(:query)           { 'last_accumulators' }

        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          properties: { errors: { type: :string} },
          required: [ 'errors' ]

        run_test!
      end
    end
  end
end
