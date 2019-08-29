require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Accumulators API", :type => :request do
  path "/api/v1/things/{thing_name}/accumulators" do
    get 'Retrieves all accumulators from a thing' do
      tags 'Accumulators'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'accumulators founded' do
        let(:user)            { create(:user) }
        let(:thing)           { accumulator.uplink.thing }
        let(:thing_name)      { accumulator.uplink.thing.name }
        let(:uplink)          { create(:uplink, thing: thing) }
        let!(:accumulator)    { create(:accumulator, value: "AA") }
        let!(:accumulator2)   { create(:accumulator, value: "BB") }
        let!(:price)          { create(:price) }
        let!(:owner)          { Owner.create(from_node: user, to_node: thing) }
        let(:Authorization)   { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            id:          { type: :string },
            value:       { type: :string },
            created_at:  { type: :string },
            updated_at:  { type: :string },
            units_count: { type: :float  },
            final_price: { type: :float  }
          },
          required: ['id', 'value', 'created_at', 'updated_at', 'units_count', 'final_price']
        }

        run_test!

      end

      response '401', 'Token is missing' do
        let(:user)        { create(:user) }
        let(:thing)       { uplink.thing.name }
        let(:thing_name)  { accumulator.uplink.thing.name  }
        let(:uplink)      { create(:uplink) }
        let(:accumulator) { create(:accumulator) }

        let(:'Authorization') { "Access denied!" }

        run_test!
      end

     response '403', 'not authorized to access' do
       let(:user_no_relations) { create(:user) }
       let(:accumulator)       { create(:accumulator) }
       let(:Authorization)     { JsonWebToken.encode({ user_id: user_no_relations.id }) }

       let(:thing_name) { accumulator.uplink.thing.name }

       run_test!
     end

       response '404', 'thing not found' do
        let(:user)          { create(:user) }
        let(:accumulator)   { create(:accumulator) }
        let(:thing)         { accumulator.uplink.thing }
        let(:uplink)        { create(:uplink, thing: thing) }
        let!(:owner)        { Owner.create(from_node: user, to_node: thing) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing_name) { "wrong_name" }

        run_test!
      end

      response '404', 'accumulators not found' do
        let(:user)          { create(:user) }
        let(:thing)         { uplink.thing }
        let(:uplink)        { create(:uplink) }
        let!(:owner)        { Owner.create(from_node: user, to_node: thing) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing_name) { uplink.thing.name }

        run_test!
      end
    end
  end
end
