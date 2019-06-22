require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Things API", :type => :request do
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
        required: thing_fields,
          properties: {
            id: { type: :string },
            name: { type: :string },
            status: { type: :string },
            pac: { type: :string },
            company_id: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            last_uplink: {
             required: uplink_fields,

              properties:{
                id: { type: :string},
                data: { type: :string},
                avgsnr: { type: :string},
                rssi: { type: :string},
                long: { type: :string},
                lat: { type: :string},
                snr: { type: :string},
                station: { type: :string},
                seqnumber: { type: :string},
                time: { type: :string},
                sec_uplinks: { type: :string},
                sec_downlinks: { type: :string},
                created_at: { type: :string },
                updated_at: { type: :string }
              }

            },
            last_messages: {
              required: messages_fields,
              items: {
                properties: {
                  accumulator: { type: :object },
                  alarm: { type: :object },
                  batteryLevel: { type: :object },
                  valvePosition: { type: :object },
                  sensor1: { type: :object },
                  sensor2: { type: :object },
                  sensor3: { type: :object },
                  sensor4: { type: :object },
                  uplinkBDownlink: { type: :object },
                  timeUplink: { type: :object }
                }
              }
            }
          }
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
