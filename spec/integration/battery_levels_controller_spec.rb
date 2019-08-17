require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Battery levels API", :type => :request do
  path "/api/v1/battery_levels" do
     get 'Retrieves all battery levels from a thing' do
      tags 'Battery Levels'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          thing_name: { type: :string },
        },
        required: [ 'thing_name' ]
      }

      response '200', 'battery levels founded' do
        let(:user) { create(:user) }
        let(:battery_level) { create(:battery_level, value: "0001") }
        let(:thing) { battery_level.uplink.thing }
        let(:uplink2) { create(:uplink, thing: thing) }
        let!(:battery_level2) { create(:battery_level, value: "0002", uplink: uplink2) }
        let!(:owner) { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            value: { type: :string },
            level_label: { type: :string },
            digit: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string }
          },
          required: [ "created_at", "updated_at", "value", "level_label", "digit"]
        }

        let!(:input) {{ thing_name: battery_level.uplink.thing.name }}

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
