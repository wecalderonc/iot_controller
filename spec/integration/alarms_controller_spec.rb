require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Alarms API", :type => :request do
  put "/api/v1/alarms/#{alarm.id}" do
    get 'Retrieves all Alarms' do
      tags 'Alarms'
      produces 'application/json'

      response '200', 'alarms founded' do
        let(:user) { create(:user) }
        let!(:alarm) { create(:alarm) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        parameter({
         viewed: true
#        :type => :string,
#        :name => :Authorization,
#         :required => true,
#        :description => 'Client token'
        })

#        schema type: :array,
#        items: {
#          type: :object,
#          properties: alarms_properties,
#          required: alarms_fields_required
#        }

        run_test!
      end
    end
  end

  path "/api/v1/things/{id}" do
    get 'Retrieves a thing' do
      tags 'Things'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'thing found' do
        let(:user) { create(:user) }
        let(:accumulator) { create(:accumulator) }
        let(:id) { accumulator.uplink.thing.id }
        let!(:owner) { Owner.create(from_node: user, to_node: accumulator.uplink.thing) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: thing_fields_required,
          properties: thing_properties
        run_test!
      end

      response '404', 'thing not found' do
        let(:user) { create(:user) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        let(:id) { "invalid_id" }

        run_test!
      end

      response '403', 'not authorized to access' do
        let(:user) { create(:user) }
        let(:accumulator) { create(:accumulator) }
        let(:id) { accumulator.uplink.thing.id }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        run_test!
      end
    end
  end

  path "/api/v1/things/{id}" do
    put 'Retrieves an updated thing' do
      tags 'Things'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          thing_name: { type: :string },
          params: {
            type: :object,
            properties: {
              name: { type: :string },
              pac:  { type: :string },
              company_id: { type: :integer },
              status: { type: :string },
              latitude: { type: :float },
              longitude: { type: :float }
            }
          }
        },
        required: [ 'thing_name', 'params']
      }

      response '200', 'thing updated' do
        let(:user) { create(:user) }
        let!(:accumulator) { create(:accumulator) }
        let!(:id) { accumulator.uplink.thing.id }
        let!(:owner) { Owner.create(from_node: user, to_node: accumulator.uplink.thing) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: thing_fields_required,
          properties: thing_properties

        let(:input) {{
            thing_name: accumulator.uplink.thing.name,
            params: {
              pac: "123456",
              company_id: 987654,
              latitude: 4.5,
              longitude: 74.6,
              name: "new_name",
              status: "deactivated"
            }
          }}

        run_test!
      end

      response '404', 'thing not found' do
        let(:user) { create(:user) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        let(:id) { "invalid_id" }

        let(:input) {{
            thing_name: "error_name",
            params: {
              pac: "123456",
              company_id: 987654,
              latitude: 4.5,
              longitude: 74.6,
              name: "new_name",
              status: "deactivated"
            }
          }}

        run_test!
      end

      response '403', 'not authorized to access' do
        let(:user) { create(:user) }
        let(:accumulator) { create(:accumulator) }
        let(:id) { accumulator.uplink.thing.id }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        let(:input) {{
            thing_name: accumulator.uplink.thing.name,
            params: {
              pac: "123456",
              company_id: 987654,
              latitude: 4.5,
              longitude: 74.6,
              name: "new_name",
              status: "deactivated"
            }
          }}

        run_test!
      end
    end
  end
end
