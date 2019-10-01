require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Accumulators Report API", :type => :request do
  path "/api/v1/accumulators_report" do
    get 'Retrieves all accumulators related with all things' do
      tags 'Alarms Report'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'accumulators founded' do
        let(:user)       { create(:user) }
        let!(:accumulator1) { create(:accumulator) }
        let!(:accumulator2) { create(:accumulator) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            thing_id: { type: :string },
            thing_name: { type: :string },
            accumulators: { 
              type: :array,
              items: {
                type: :object,
                properties: {
                  date: { type: :string },
                  value: { type: :string },
                  consumption_delta: { type: :integer },
                  accumulated_delta: { type: :integer }
                }
              }
            }
          },
          required: ['thing_id', 'thing_name', 'accumulators']
        }

        run_test!
      end

      response '404', 'Results not found' do
        let(:user) { create(:user) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          properties: {
            errors: { type: :string },
            code: { type: :integer }
          },
          required: [ 'errors', 'code' ]

        run_test!
      end
    end
  end

  path "/api/v1/accumulators_report/{thing_name}" do
    get 'Retrieves all accumulators related with a specific things' do
      tags 'Alarms Report'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'accumulators founded' do
        let(:user)         { create(:user) }
        let(:accumulator1) { create(:accumulator) }
        let(:thing_name)   { accumulator1.uplink.thing.name }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            thing_id: { type: :string },
            thing_name: { type: :string },
            accumulators: { 
              type: :array,
              items: {
                type: :object,
                properties: {
                  date: { type: :string },
                  value: { type: :string },
                  consumption_delta: { type: :integer },
                  accumulated_delta: { type: :integer }
                }
              }
            }
          },
          required: ['thing_id', 'thing_name', 'accumulators']
        }

        run_test!
      end

      response '404', 'The thing thing_name does not exist' do
        let(:user)         { create(:user) }
        let(:thing_name)   { 'invalid_name' }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          properties: {
            errors: { type: :string },
            code: { type: :integer }
          },
          required: [ 'errors', 'code' ]

        run_test!
      end
    end
  end
end
