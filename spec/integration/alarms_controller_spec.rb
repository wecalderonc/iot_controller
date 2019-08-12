require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Alarms API", :type => :request do
  path "/api/v1/alarms/{id}" do
    put 'Retrieves a viewed alarm' do
      tags 'Alarms'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string·
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'alarms founded' do
        let(:user) { create(:user) }
        let(:alarm) { create(:alarm) }
        let(:id) { alarm.id }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: ['alarm'],
          properties: {
            alarm: {
              required: ['created_at', 'updated_at', 'value', 'date', 'viewed', 'id'],
              properties: {
                created_at: { type: :string },
                updated_at: { type: :string },
                value:      { type: :string },
                date:       { type: :date },
                viewed:     { type: :boolean},
                id:         { type: :string}
              }
            }
          }

        run_test!
      end

      response '401', 'Token is missing' do
        let(:user) { create(:user) }
        let(:alarm) { create(:alarm) }
        let(:id) { alarm.id }

        let(:'Authorization') { "Access denied!" }

        run_test!
      end

      response '200', 'The alarm does not exist' do
        let(:user) { create(:user) }
        let(:alarm) { create(:alarm) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:id) { "invalid_id" }

        run_test!
      end
    end
  end
end
