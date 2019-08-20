require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Battery levels API", :type => :request do
  path "/api/v1/things/{thing_name}/battery_levels" do
     get 'Retrieves all battery levels from a thing' do
      tags 'Battery Levels'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: :thing_name, :in => :path, :type => :string

      response '200', 'battery levels founded' do
        let(:user) { create(:user) }
        let(:battery_level) { create(:battery_level, value: "0001") }
        let(:thing) { battery_level.uplink.thing }
        let(:thing_name) { battery_level.uplink.thing.name }
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
            digit: { type: :integer },
            created_at: { type: :string },
            updated_at: { type: :string }
          },
          required: [ "created_at", "updated_at", "value", "level_label", "digit"]
        }

        run_test!
      end

       response '404', 'thing not found' do
        let(:user) { create(:user) }
        let(:battery_level) { create(:battery_level, value: "0001") }
        let(:thing) { battery_level.uplink.thing }
        let(:uplink2) { create(:uplink, thing: thing) }
        let!(:battery_level2) { create(:battery_level, value: "0002", uplink: uplink2) }
        let!(:owner) { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing_name) { "wrong_thing_name" }

        run_test!
      end

      response '403', 'not authorized to access' do
        let(:user_no_relations) { create(:user) }
        let(:battery_level) { create(:battery_level) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user_no_relations.id }) }

        let(:thing_name) { battery_level.uplink.thing.name }

        run_test!
      end
    end
  end
end
