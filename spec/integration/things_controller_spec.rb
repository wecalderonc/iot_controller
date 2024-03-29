require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Things API", :type => :request do
  path "/api/v1/things" do
     get 'Retrieves all Things' do
      tags 'Things'
      produces 'application/json'

      response '200', 'things founded' do
        let(:user) { create(:user) }
        let!(:thing) { create(:thing) }
        let!(:thing2) { create(:thing) }
        let!(:thing3) { create(:thing) }
        let!(:owner)  { Owner.create(from_node: user, to_node: thing) }
        let!(:owner2) { Owner.create(from_node: user, to_node: thing2) }
        let!(:owner3) { Owner.create(from_node: user, to_node: thing3) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        parameter({
         :in => :header,
         :type => :string,
         :name => :Authorization,
         :required => true,
         :description => 'Client token'
        })

        schema type: :array,
        items: {
          type: :object,
          properties: things_properties,
          required: things_fields_required
        }

        run_test!
      end
    end
  end

  path "/api/v1/things/{thing_name}" do
    get 'Retrieves a thing' do
      tags 'Things'
      produces 'application/json'
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'thing found' do
        let(:user) { create(:user) }
        let(:accumulator) { create(:accumulator) }
        let(:thing_name) { accumulator.uplink.thing.name }
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
        let(:accumulator) { create(:accumulator) }
        let!(:owner) { Owner.create(from_node: user, to_node: accumulator.uplink.thing) }

        let(:thing_name) { "thing_not_created" }

        run_test!
      end
    end
  end

  path "/api/v1/things/{thing_name}" do
    put 'Retrieves an updated thing' do
      tags 'Things'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
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
        required: ['params']
      }

      response '200', 'thing updated' do
        let(:user) { create(:user) }
        let!(:accumulator) { create(:accumulator) }
        let!(:thing_name) { accumulator.uplink.thing.name }
        let!(:owner) { Owner.create(from_node: user, to_node: accumulator.uplink.thing) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: thing_fields_required,
          properties: thing_properties

        let(:input) {{
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
        let(:accumulator) { create(:accumulator) }
        let(:thing_name) { accumulator.uplink.thing.name }
        let!(:owner) { Owner.create(from_node: user, to_node: accumulator.uplink.thing) }

        let(:thing_name) { "invalid_name" }

        let(:input) {{
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
        let(:thing_name) { accumulator.uplink.thing.name }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        let(:input) {{
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
