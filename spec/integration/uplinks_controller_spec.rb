require 'swagger_helper'

RSpec.describe "Uplinks API", :type => :request do
  path "/api/v1/uplinks" do
    get 'Retrieves all Uplinks' do
      tags 'Uplinks'
      produces 'application/json'

      response '200', 'last uplink found' do
        let(:user) { create(:user) }
        let!(:uplink) { create(:uplink) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }
        parameter({
         :in => :header,
         :type => :string,
         :name => :Authorization,
         :required => true,
         :description => 'Client token'
        })

        schema type: :object,
          required: last_uplink_fields,
          properties: last_uplink_properties

        run_test!
      end

      response '404', 'no uplinks found' do
        let(:user) { create(:user) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }
        run_test!
      end
    end
  end
end
