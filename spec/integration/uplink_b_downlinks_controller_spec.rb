require 'swagger_helper'

RSpec.describe "Uplink between Downlinks API", :type => :request do
  path "/api/v1/things/{id}/uplink_b_downlinks" do
    get 'Retrieves all Uplink between Downlinks of a Thing' do
      tags 'Uplink between Downlinks'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'all accumulators ' do
        let(:user)              { create(:user) }
        let(:uplinkBDownlink) { create(:uplink_b_downlink) }
        let(:thing)             { uplinkBDownlink.uplink.thing }
        let(:id)                { uplinkBDownlink.uplink.thing.id }

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
            properties: {
              id: { type: :string },
              value: { type: :string },
              created_at: { type: :string },
              updated_at: { type: :string },
            },
            required: [ 'id', 'value', :created_at, :updated_at ]
          }
        run_test!
      end

      response '404', 'thing doesnt exist' do
        let(:user) { create(:user) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }

        let(:id) { "invalid_id" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).to eq("Thing doesn't exist")
        end
      end
    end
  end
end
