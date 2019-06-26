require 'swagger_helper'

RSpec.describe "Downlinks API", :type => :request do
  path "/api/v1/downlinks" do
    post 'Generates a downlink' do
      tags 'Downlinks'
      produces 'application/json'

      response '200', 'Downlink generated' do
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
          required: [ 'downlink' ],
          properties: {
            uplink: {
              type: :object,
              #required: [ 'id', 'data', 'avgsnr', 'rssi', 'long', 'lat', 'snr', 'station', 'seqnumber', 'time', 'sec_uplinks', 'sec_downlinks' ],
              items: {
                  properties: { }
              }
            }
          }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:user) { create(:user) }
        let(:'Authorization') { "" }

        run_test!
      end
    end
  end
end
