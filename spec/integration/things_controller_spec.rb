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
    end
  end
end
